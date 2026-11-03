package com.ayjs.mxzg.tools.client.stresstest;

import com.ayjs.mxzg.common.netty.GameMessage;
import com.ayjs.mxzg.common.util.MessageUtils;
import com.ayjs.mxzg.tools.client.client.ClientCMD;
import com.ayjs.mxzg.tools.client.client.base.ClientResponseHandler;
import com.ayjs.mxzg.tools.client.client.base.ClientResponseHandlerRegistry;
import com.ayjs.mxzg.tools.client.client.base.ProtocolRegistry;
import com.ayjs.mxzg.tools.client.client.network.ClientSession;
import com.google.protobuf.Message;
import io.netty.channel.ChannelHandlerContext;
import io.netty.channel.SimpleChannelInboundHandler;
import io.netty.handler.timeout.IdleState;
import io.netty.handler.timeout.IdleStateEvent;
import io.netty.util.AttributeKey;
import lombok.extern.slf4j.Slf4j;

import java.util.Objects;

/**
 * 压测程序处理
 *
 * @author tangyangbo 2019/8/30 20:47
 */
@Slf4j
public class ClientStressTestHandler extends SimpleChannelInboundHandler<Object> {

    @Override
    public void channelActive(ChannelHandlerContext ctx) throws Exception {
        log.debug("channelActive:{}", ctx.channel().toString());
    }

    @Override
    public void channelInactive(ChannelHandlerContext ctx) throws Exception {
        super.channelInactive(ctx);
        ctx.channel().close();
    }

    @Override
    protected void channelRead0(ChannelHandlerContext ctx, Object msg) throws Exception {
        GameMessage serverMsg = (GameMessage) msg;

        try {
            if (Objects.isNull(serverMsg)) {
                log.debug("serverMsg is null.");
                return;
            }
            if (serverMsg.getCmd() <= 0) {
                log.debug("cmd:{}", serverMsg.getCmd());
                return;
            }
            AttributeKey<ClientSession> key = AttributeKey.valueOf(ClientCMD.CLIENT_KEY);
            ClientSession clientSession = ctx.channel().attr(key).get();


//            log.info("message id: {} ,msg:{}", serverMsg.getCmd(), JSONObject.toJSONString(serverMsg));
//
            Message rspMessage = ProtocolRegistry.getRspMessage(serverMsg.getCmd());
            if (Objects.isNull(rspMessage)) {
                log.error("ProtocolRegistry protocol:{} is not registry.", serverMsg.getCmd());
                return;
            }

            Message messageData = build(rspMessage, serverMsg.getMsg());
            if (Objects.isNull(messageData)) {
                log.error("protocol:{} is messageData is null.", serverMsg.getCmd());
                return;
            }

            log.debug("protocol:{} message:{}", serverMsg.getCmd(), MessageUtils.formatMessage(messageData, true));
            ClientResponseHandler handler = ClientResponseHandlerRegistry.getHandler(serverMsg.getCmd());
            if (handler == null) {
                log.warn("protocol:{} is handler is null.", serverMsg.getCmd());
                return;
            }
            handler.handler(clientSession, messageData);
        } catch (Throwable t) {
            log.error("serverMsg:{}", serverMsg.getCmd());
            log.error("Throwable", t);
        }


    }

    @Override
    public void exceptionCaught(ChannelHandlerContext ctx, Throwable cause) throws Exception {
        log.error("exceptionCaught", cause);
    }

    @Override
    public void userEventTriggered(ChannelHandlerContext ctx, Object evt) throws Exception {
        super.userEventTriggered(ctx, evt);
        if (evt instanceof IdleStateEvent) {
            IdleStateEvent idleStateEvent = (IdleStateEvent) evt;
            if (idleStateEvent.state() == IdleState.READER_IDLE) {
                log.info("client {} IdleStateEvent READER_IDLE.", ctx.channel().remoteAddress());
            }

        }
    }


    protected Message build(Message prototype, byte[] data) {
        try {
            return prototype.getParserForType().parseFrom(data);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}