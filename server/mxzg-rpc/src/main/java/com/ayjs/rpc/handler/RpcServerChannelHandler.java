package com.ayjs.rpc.handler;

import com.ayjs.rpc.server.Connection;
import com.ayjs.rpc.server.ConnectionManager;
import com.ayjs.rpc.util.InstanceFactory;
import io.netty.channel.ChannelHandlerContext;
import io.netty.channel.ChannelInboundHandlerAdapter;
import io.netty.handler.timeout.IdleState;
import io.netty.handler.timeout.IdleStateEvent;
import io.netty.util.Attribute;
import io.netty.util.AttributeKey;
import lombok.extern.slf4j.Slf4j;

import java.util.concurrent.atomic.AtomicInteger;

/**
 * 服务器ChannelHandler
 */
@Slf4j
public class RpcServerChannelHandler extends ChannelInboundHandlerAdapter {

    private static AtomicInteger clientIdBuilder = new AtomicInteger(1);

    @Override
    public void channelActive(ChannelHandlerContext ctx) throws Exception {
        Connection connection = attribute(ctx).get();
        connection.setClientId(clientIdBuilder.getAndIncrement());
        InstanceFactory.getInstance(ConnectionManager.class).addConnection(connection);
        super.channelActive(ctx);
    }

    @Override
    public void channelInactive(ChannelHandlerContext ctx) throws Exception {
        Connection connection = attribute(ctx).get();
        if (connection != null && connection.getClientId() != 0) {
            InstanceFactory.getInstance(ConnectionManager.class).removeConnection(connection.getClientId());
        }
    }

    protected Attribute<Connection> attribute(ChannelHandlerContext ctx) {
        AttributeKey<Connection> key = AttributeKey.valueOf("connection");
        return ctx.channel().attr(key);
    }

    @Override
    public void userEventTriggered(ChannelHandlerContext ctx, Object evt) throws Exception {
        if (evt instanceof IdleStateEvent) {
            IdleStateEvent event = (IdleStateEvent) evt;
            if (event.state() == IdleState.READER_IDLE) {
                ctx.channel().close();
                log.info("关闭空闲连接{}", ctx.channel().remoteAddress());
            }
        }
    }
}
