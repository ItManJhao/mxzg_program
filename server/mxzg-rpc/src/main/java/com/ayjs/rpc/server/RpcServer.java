package com.ayjs.rpc.server;

import com.ayjs.rpc.handler.RpcChannelHandler;
import com.ayjs.rpc.handler.RpcMessageDecoder;
import com.ayjs.rpc.handler.RpcMessageEncoder;
import com.ayjs.rpc.handler.RpcServerChannelHandler;
import com.ayjs.rpc.util.InstanceFactory;
import io.netty.bootstrap.ServerBootstrap;
import io.netty.channel.*;
import io.netty.channel.nio.NioEventLoopGroup;
import io.netty.channel.socket.nio.NioServerSocketChannel;
import io.netty.handler.codec.LengthFieldBasedFrameDecoder;
import io.netty.handler.timeout.IdleStateHandler;
import io.netty.util.Attribute;
import io.netty.util.AttributeKey;

import java.util.concurrent.atomic.AtomicInteger;

/**
 * RPC服务器
 *
 * @author Alias
 * @date 2017年11月10日 下午1:52:30
 */
public class RpcServer {

    private static final int MAX_FRAME_LENGTH = 64 * 1024 * 1024;
    private int port;

    public RpcServer(int port) {
        this.port = port;
    }

    public void start() {
        ServerBootstrap bootstrap = new ServerBootstrap();
        EventLoopGroup main = new NioEventLoopGroup(1);
        bootstrap.group(main);
        bootstrap.channel(NioServerSocketChannel.class);
        bootstrap.childHandler(new ChannelInitializer<Channel>() {

            @Override
            protected void initChannel(Channel ch) throws Exception {
                ChannelPipeline pipeline = ch.pipeline();
                pipeline.addLast(new IdleStateHandler(10, 0, 0));
                pipeline.addLast(new LengthFieldBasedFrameDecoder(MAX_FRAME_LENGTH, 0, 4, 0, 4));
                pipeline.addLast(new RpcMessageDecoder());
                pipeline.addLast(new RpcMessageEncoder());
                pipeline.addLast(new RpcChannelHandler());
                pipeline.addLast(new RpcServerChannelHandler());
            }
        });
        bootstrap.bind(port);
    }

    /**
     * 用于管理连接
     *
     * @author Alias
     * @date 2018年1月30日 下午7:32:03
     */
    class ConnectionsHandler extends ChannelInboundHandlerAdapter {

        private AtomicInteger clientIdBuilder = new AtomicInteger(1);

        @Override
        public void channelActive(ChannelHandlerContext ctx) throws Exception {
            Connection connection = new Connection(ctx.channel());
            connection.setClientId(clientIdBuilder.getAndIncrement());
            InstanceFactory.getInstance(ConnectionManager.class).addConnection(connection);
            attribute(ctx).set(connection);
            super.channelActive(ctx);
        }

        @Override
        public void channelInactive(ChannelHandlerContext ctx) throws Exception {
            Connection connection = attribute(ctx).get();
            if (connection != null) {
                InstanceFactory.getInstance(ConnectionManager.class).removeConnection(connection.getClientId());
            }
            super.channelInactive(ctx);
        }

        private Attribute<Connection> attribute(ChannelHandlerContext ctx) {
            AttributeKey<Connection> key = AttributeKey.valueOf("connection");
            return ctx.channel().attr(key);
        }
    }
}
