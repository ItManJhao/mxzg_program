package com.ayjs.rpc.handler;

import com.alibaba.fastjson.JSON;
import com.ayjs.rpc.HeartbeatMessage;
import com.ayjs.rpc.client.Request;
import com.ayjs.rpc.dispatcher.ConsumerHolder;
import com.ayjs.rpc.server.Connection;
import com.ayjs.rpc.server.Response;
import com.ayjs.rpc.server.RpcDispatcher;
import com.ayjs.rpc.util.InstanceFactory;
import io.netty.channel.ChannelHandlerContext;
import io.netty.channel.ChannelInboundHandlerAdapter;
import io.netty.util.Attribute;
import io.netty.util.AttributeKey;
import lombok.extern.slf4j.Slf4j;

/**
 * @author Alias
 * @date 2017年12月11日 上午10:53:02
 */
@Slf4j
public class RpcChannelHandler extends ChannelInboundHandlerAdapter {

    @Override
    public void channelRead(ChannelHandlerContext ctx, Object msg) throws Exception {
        if (msg instanceof Response) {
            if (log.isDebugEnabled()) {
                Response response = (Response) msg;
                log.debug("--->收到响应消息{}内容:{}", response.getResult().getClass(), JSON.toJSON(response.getResult()));
            }
            handleResponse(ctx, msg);
        } else if (msg instanceof Request) {
            if (log.isDebugEnabled()) {
                Request request = (Request) msg;
                if (!(request.getMessage() instanceof HeartbeatMessage)) {
                    log.debug("--->收到请求消息{}内容:{}", request.getMessage().getClass(), JSON.toJSON(request.getMessage()));
                }
            }
            handleRequest(ctx, msg);
        } else {
            log.error("Can not handle this type:" + msg.getClass().getName());
        }
    }

    @Override
    public void channelActive(ChannelHandlerContext ctx) throws Exception {
        Connection connection = new Connection(ctx.channel());
        attribute(ctx).set(connection);
        super.channelActive(ctx);
    }

    protected Attribute<Connection> attribute(ChannelHandlerContext ctx) {
        AttributeKey<Connection> key = AttributeKey.valueOf("connection");
        return ctx.channel().attr(key);
    }

    private void handleRequest(ChannelHandlerContext ctx, Object msg) {
        Request request = (Request) msg;
        Connection connection = attribute(ctx).get();
        InstanceFactory.getInstance(RpcDispatcher.class).dispatch(request, connection);
    }

    @SuppressWarnings({"rawtypes", "unchecked"})
    private void handleResponse(ChannelHandlerContext ctx, Object msg) {
        Response response = (Response) msg;
        Connection connection = attribute(ctx).get();
        InstanceFactory.getInstance(ConsumerHolder.class).consume(response, connection);
    }

    @Override
    public void userEventTriggered(ChannelHandlerContext ctx, Object evt) throws Exception {
    }
}
