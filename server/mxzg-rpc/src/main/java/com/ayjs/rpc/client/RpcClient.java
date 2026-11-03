package com.ayjs.rpc.client;

import com.ayjs.rpc.RemoteMessage;
import com.ayjs.rpc.handler.RpcChannelHandler;
import com.ayjs.rpc.handler.RpcMessageDecoder;
import com.ayjs.rpc.handler.RpcMessageEncoder;
import com.ayjs.rpc.util.InstanceFactory;
import com.ayjs.rpc.util.RequestUtil;
import io.netty.bootstrap.Bootstrap;
import io.netty.channel.Channel;
import io.netty.channel.ChannelFuture;
import io.netty.channel.ChannelHandlerContext;
import io.netty.channel.ChannelInboundHandlerAdapter;
import io.netty.channel.ChannelInitializer;
import io.netty.channel.ChannelOption;
import io.netty.channel.ChannelPipeline;
import io.netty.channel.EventLoopGroup;
import io.netty.channel.nio.NioEventLoopGroup;
import io.netty.channel.socket.nio.NioSocketChannel;
import io.netty.handler.codec.LengthFieldBasedFrameDecoder;
import io.netty.handler.timeout.IdleStateHandler;
import lombok.extern.slf4j.Slf4j;

import java.util.concurrent.atomic.AtomicReference;

/**
 * RPC客户端
 *
 * @author Alias
 * @date 2017年12月11日 上午10:54:29
 */
@Slf4j
public class RpcClient {

    private static final int MAX_FRAME_LENGTH = 64 * 1024 * 1024;

    private final String host;

    private final int port;

    private final AtomicReference<Channel> channelRef = new AtomicReference<>();

    private final Bootstrap bootstrap = new Bootstrap();

    public RpcClient(String host, int port) {
        this.host = host;
        this.port = port;
    }

    public void start() {
        createBootstrap();
    }

    public String getHost() {
        return host;
    }

    public int getPort() {
        return port;
    }

    public Channel getChannel() {
        return channelRef.get();
    }

    public Bootstrap getBootstrap() {
        return bootstrap;
    }

    public boolean channelIsActive() {
        return channelRef.get() != null && channelRef.get().isActive();
    }

    public void setChannel(Channel channel) {
        close();
        channelRef.set(channel);
    }

    public void close() {
        Channel channel = channelRef.get();
        if (channel != null && channel.isActive()) {
            channel.close();
        }
    }

    private void createBootstrap() {
        EventLoopGroup group = new NioEventLoopGroup();
        bootstrap.group(group);
        bootstrap.channel(NioSocketChannel.class);
        bootstrap.option(ChannelOption.CONNECT_TIMEOUT_MILLIS, 2000);
        bootstrap.handler(new ChannelInitializer<Channel>() {

            @Override
            protected void initChannel(Channel ch) throws Exception {
                ChannelPipeline pipeline = ch.pipeline();
                pipeline.addLast(new IdleStateHandler(5, 0, 0));
                pipeline.addLast(new LengthFieldBasedFrameDecoder(MAX_FRAME_LENGTH, 0, 4, 0, 4));
                pipeline.addLast(new RpcMessageEncoder());
                pipeline.addLast(new RpcMessageDecoder());
                pipeline.addLast(new RpcChannelHandler());
//                pipeline.addLast(new ReconnectionHandler(bootstrap));
                pipeline.addLast(new ChannelInboundHandlerAdapter() {

                    @Override
                    public void channelInactive(ChannelHandlerContext ctx) throws Exception {
                        log.info("链接已经断开{}:{}", host, port);
                        channelRef.set(null);
                    }
                });
            }
        });
    }

    /**
     * 异步调用
     *
     * @param message
     * @return
     */
    @Deprecated
    public <T> ResponseFuture<T> call(RemoteMessage message) {
        Request request = RequestUtil.createAndSetRequestId(message);
        ResponseFuture<T> future = new ResponseFuture<>(request);
        InstanceFactory.getInstance(RpcContext.class).addCallback(future);
        Channel channel = getChannel();
        if (channel != null && channel.isActive()) {
            channel.writeAndFlush(request);
        }
        return future;
    }

    /**
     * 异步调用，并标记该请求需要等待回调
     *
     * @param message
     * @return
     */
    public Request sendAndMark(RemoteMessage message) {
        Request request = RequestUtil.createAndSetRequestId(message);
        Channel channel = getChannel();
        if (channel != null && channel.isActive()) {
            channel.writeAndFlush(request);
        }
        return request;
    }

    /**
     * 发送请求并返回请求对象
     *
     * @param message
     * @return
     */
    public void send(RemoteMessage message) {
        Request request = RequestUtil.createRequest(message);
        Channel channel = getChannel();
        if (channel != null && channel.isActive()) {
            channel.writeAndFlush(request);
        }
    }

    public ChannelFuture connect() {
        return bootstrap.connect(host, port);
    }

    public Channel createChannel() {
        Channel channel = channelRef.get();
        if (channel == null || !channel.isActive()) {
            ChannelFuture future = connect();
            if (future.awaitUninterruptibly(3000)) {
                if (future.channel() != null && future.channel().isActive()) {
                    if (channelRef.compareAndSet(channel, future.channel())) {
                        return future.channel();
                    }
                } else {
                    log.info("远程服务器{}:{}连接失败!", this.host, this.port);
                }
            }
        }
        return channel;
    }

}
