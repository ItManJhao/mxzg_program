/**
 *
 */
package com.ayjs.mxzg.gameserver.infrastructure.netty;

import com.ayjs.mxzg.common.base.SpringProxy;
import com.ayjs.mxzg.common.netty.GameMessage;
import io.netty.channel.ChannelHandler.Sharable;
import io.netty.channel.ChannelHandlerContext;
import io.netty.channel.SimpleChannelInboundHandler;
import io.netty.handler.timeout.IdleState;
import io.netty.handler.timeout.IdleStateEvent;
import io.netty.util.AttributeKey;
import lombok.extern.slf4j.Slf4j;

/**
 * @author YY
 *
 */
@Slf4j
@Sharable
public class NettyHandler extends SimpleChannelInboundHandler<GameMessage> {

    private final AttributeKey<PlayerContext> PLAYERCONTEXT = AttributeKey.newInstance("PLAYERCONTEXT");

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
    protected void channelRead0(ChannelHandlerContext ctx, GameMessage msg) throws Exception {
        PlayerContext playerContext = ctx.channel().attr(PLAYERCONTEXT).get();
        if (playerContext == null) {
            return;
        }
        playerContext.getActor().process(playerContext, msg);
    }

    @Override
    public void channelWritabilityChanged(ChannelHandlerContext ctx) throws Exception {
        if (ctx.channel().isWritable()) {
            PlayerContext playerContext = ctx.channel().attr(PLAYERCONTEXT).get();
            if (log.isDebugEnabled())
                log.debug("connection[" + playerContext + "] is available, flush the queue of connection");
            if (playerContext.isChannelAlive()) {
                playerContext.getChannel().flush();
                System.out.println("channelWritabilityChanged");
            }
        }
        super.channelWritabilityChanged(ctx);
    }

    @Override
    public void exceptionCaught(ChannelHandlerContext ctx, Throwable cause) throws Exception {
        if("Connection reset by peer".equals(cause.getMessage())) {
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
        super.userEventTriggered(ctx, evt);
    }
}
