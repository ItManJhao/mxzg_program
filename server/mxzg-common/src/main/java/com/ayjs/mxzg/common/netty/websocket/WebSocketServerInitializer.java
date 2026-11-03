package com.ayjs.mxzg.common.netty.websocket;

import io.netty.channel.ChannelHandler;
import io.netty.channel.ChannelInitializer;
import io.netty.channel.ChannelPipeline;
import io.netty.channel.socket.SocketChannel;
import io.netty.handler.codec.http.HttpObjectAggregator;
import io.netty.handler.codec.http.HttpServerCodec;
import io.netty.handler.codec.http.websocketx.WebSocketServerProtocolHandler;
import io.netty.handler.ssl.SslContext;
import io.netty.handler.ssl.SslHandler;
import io.netty.handler.stream.ChunkedWriteHandler;
import io.netty.handler.timeout.IdleStateHandler;

import javax.net.ssl.SSLEngine;

public class WebSocketServerInitializer extends ChannelInitializer<SocketChannel> {
    private SslContext sslCtx;
    private ChannelHandler[] handlers;
    private int idle;

    public WebSocketServerInitializer(int idle, ChannelHandler... handlers) {
        this.handlers = handlers;
        this.idle = idle;
    }

    public WebSocketServerInitializer(SslContext sslCtx, int idle, ChannelHandler... handlers) {
        this.sslCtx = sslCtx;
        this.idle = idle;
        this.handlers = handlers;
    }

    @Override
    public void initChannel(SocketChannel ch) {
        ChannelPipeline pipeline = ch.pipeline();
        if (sslCtx != null) {
            SSLEngine sslEngine = sslCtx.newEngine(ch.alloc());
            sslEngine.setUseClientMode(false);
            pipeline.addLast(new SslHandler(sslEngine));
        }

        pipeline.addLast(new HttpServerCodec());
        pipeline.addLast(new HttpObjectAggregator(65536));
        pipeline.addLast(new ChunkedWriteHandler());
        //idle 心跳监测
        pipeline.addLast(new IdleStateHandler(idle, 0, 0));
        pipeline.addLast(new WebSocketServerProtocolHandler("/", null, true, 192 * 1024));
        pipeline.addLast(new WebSocketCodec());

        if (handlers != null) {
            pipeline.addLast(handlers);
        }
    }
}
