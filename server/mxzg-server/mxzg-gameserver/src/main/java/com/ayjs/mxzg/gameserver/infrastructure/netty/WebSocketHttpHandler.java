package com.ayjs.mxzg.gameserver.infrastructure.netty;

import com.ayjs.mxzg.common.base.SpringProxy;
import com.ayjs.mxzg.common.netty.GameMessage;
import io.netty.buffer.ByteBuf;
import io.netty.channel.ChannelHandler;
import io.netty.channel.ChannelHandlerContext;
import io.netty.channel.SimpleChannelInboundHandler;
import io.netty.handler.codec.http.FullHttpRequest;
import io.netty.handler.codec.http.HttpHeaderNames;
import io.netty.handler.codec.http.HttpHeaders;
import io.netty.handler.codec.http.HttpMethod;
import io.netty.handler.codec.http.websocketx.*;
import io.netty.handler.timeout.IdleState;
import io.netty.handler.timeout.IdleStateEvent;
import io.netty.util.AttributeKey;
import lombok.extern.slf4j.Slf4j;

import java.util.Map;

@Slf4j
@ChannelHandler.Sharable
public class WebSocketHttpHandler extends SimpleChannelInboundHandler<Object> {

    private final AttributeKey<PlayerContext> PLAYERCONTEXT = AttributeKey.newInstance("WEB-PLAYERCONTEXT");

    @Override
    public void channelActive(ChannelHandlerContext ctx) throws Exception {
        super.channelActive(ctx);
        PlayerContext playerContext = new PlayerContext(ctx.channel());
        ctx.channel().attr(PLAYERCONTEXT).set(playerContext);
    }

    @Override
    public void channelInactive(ChannelHandlerContext ctx) throws Exception {
        PlayerContext playerContext = ctx.channel().attr(PLAYERCONTEXT).get();
        if (playerContext != null) {
            ctx.channel().attr(PLAYERCONTEXT).set(null);
            playerContext.setChannel(null);
            SpringProxy.getBean(ContextManager.class).playerOffline(playerContext, OfflineEvent.NettyHandler_channelInactive);
        }
        super.channelInactive(ctx);
    }

    @Override
    public void channelRead0(ChannelHandlerContext ctx, Object msg) throws Exception {
        if (msg instanceof FullHttpRequest) {
            handleHttpRequest(ctx, (FullHttpRequest) msg);
        } else if (msg instanceof WebSocketFrame) {
            handleWebSocketRequest(ctx, (WebSocketFrame) msg);
        }
    }

    @Override
    public void channelWritabilityChanged(ChannelHandlerContext ctx) throws Exception {
        if (ctx.channel().isWritable()) {
            PlayerContext playerContext = ctx.channel().attr(PLAYERCONTEXT).get();
            if (log.isDebugEnabled())
                log.debug("connection[" + playerContext + "] is available, flush the queue of connection");
            if (playerContext.isChannelAlive()) {
                playerContext.getChannel().flush();
                log.debug("channelWritabilityChanged isChannelAlive");
            }
        }
        super.channelWritabilityChanged(ctx);
    }

    @Override
    public void exceptionCaught(ChannelHandlerContext ctx, Throwable cause) throws Exception {
        if ("Connection reset by peer".equals(cause.getMessage())) {
            log.error("handle from [" + ctx.channel().id().asLongText() + "] failed! Connection reset by peer");
        } else {
            log.error("handle from [" + ctx.channel().id().asLongText() + "] failed!", cause);
        }
        PlayerContext playerContext = ctx.channel().attr(PLAYERCONTEXT).get();
        if (playerContext != null) {
            playerContext.closeChannel();
        } else {
            log.error("connection[" + ctx.channel().id().asLongText() + "] not found in manager");
            ctx.channel().close();
        }
    }

    @Override
    public void userEventTriggered(ChannelHandlerContext ctx, Object evt) throws Exception {
        if (evt instanceof IdleStateEvent) {
            IdleStateEvent event = (IdleStateEvent) evt;
            if (event.state() == IdleState.READER_IDLE) {
                log.info("空闲超时: id=" + ctx.channel().id() + ", remoteAddress=" + ctx.channel().remoteAddress());
                PlayerContext playerContext = ctx.channel().attr(PLAYERCONTEXT).get();
                if (playerContext != null) {
                    playerContext.closeChannel();
                }
            }
        }
        if (evt instanceof WebSocketServerProtocolHandler.ServerHandshakeStateEvent) {
            log.info("userEventTriggered:{}", evt);
        }
        super.userEventTriggered(ctx, evt);
    }

    /**
     * 处理HTTP请求
     *
     * @param ctx
     * @param req
     */
    private void handleHttpRequest(ChannelHandlerContext ctx, FullHttpRequest req) {
        HttpHeaders headers = req.headers();
        Map<String, String> params = null;

        if (req.method() == HttpMethod.GET) { // 处理get请求
            // 屏蔽掉非websocket握手请求
            // 只接受http GET和headers['Upgrade']为'websocket'的http请求
            if ("websocket".equalsIgnoreCase(headers.get("Upgrade"))) {
                WebSocketServerHandshakerFactory wsShakerFactory = new WebSocketServerHandshakerFactory("ws://" + req.headers().get(HttpHeaderNames.HOST), null, false);

                WebSocketServerHandshaker wsShakerHandler = wsShakerFactory.newHandshaker(req);
                if (wsShakerHandler == null) {
                    // 无法处理的websocket版本
                    WebSocketServerHandshakerFactory.sendUnsupportedVersionResponse(ctx.channel());
                } else {
                    // 向客户端发送websocket握手,完成握手
                    // 客户端收到的状态是101 sitching protocol
                    wsShakerHandler.handshake(ctx.channel(), req);
                }
                return;
            }
        }
    }

    /**
     * 处理WebSocket请求s
     *
     * @param ctx
     * @param request
     */
    private void handleWebSocketRequest(ChannelHandlerContext ctx, WebSocketFrame request) {
        if (request instanceof CloseWebSocketFrame) {
            ctx.channel().close();
        } else if (request instanceof PingWebSocketFrame) {
            // channel.write(new PongWebSocketFrame(request.getBinaryData()));
        } else if (request instanceof TextWebSocketFrame) {
            // 这个地方 可以根据需求，加上一些业务逻辑
        } else if (request instanceof BinaryWebSocketFrame) {
            BinaryWebSocketFrame frame = (BinaryWebSocketFrame) request;
            ByteBuf buffer = frame.content();
            int size = buffer.readableBytes();
            //当前流中的数组长度还小于4，不符合一个完整消息的规定，需要等流收集到足够的数据才继续处理
            if (size < 8) {
                return;
            }
            //读取一个int来确认消息的长度，并使读取索引移动4位
            int dataLength = buffer.readInt();
            //协议号
            if (dataLength <= 0 || dataLength > size - 4) {
                //当流中的数据长度没有达到消息长度的要求时，说明该消息还没有被完全读取，
                //需要等流收集到足够的数据时才能继续处理
                //但上述的readInt时数组索引已经移动了4位，所以需要把读取索引重设回标记读取索引的位置
                buffer.resetReaderIndex();
                return;
            }
            int cmd = buffer.readInt();
            byte[] decoded = new byte[dataLength - 4];
            buffer.readBytes(decoded);
            //标记数组的读取索引
            buffer.markReaderIndex();

            GameMessage message = new GameMessage();
            message.setCmd(cmd);
            message.setMsg(decoded);

            PlayerContext playerContext = ctx.channel().attr(PLAYERCONTEXT).get();
            if (playerContext == null) {
                log.error("handleWebSocketRequest playerContext is null:{} cmd:{}", ctx, message.getCmd());
                return;
            }
            playerContext.getActor().process(playerContext, message);
        } else {
            // WebSocketFrame还有一些
            log.debug("request:" + request);
        }
    }

}