package com.ayjs.mxzg.common.netty;

import io.netty.channel.ChannelInboundHandlerAdapter;
import io.netty.channel.ChannelInitializer;
import io.netty.channel.ChannelPipeline;
import io.netty.channel.socket.SocketChannel;
import io.netty.handler.timeout.IdleStateHandler;

/**
 * 以小端序编解码
 */
public class LittleEndianChannelInitializer extends ChannelInitializer<SocketChannel> {

    private ChannelInboundHandlerAdapter handler;
    /**
     * 空闲检测时间
     */
    private int idle;

    public LittleEndianChannelInitializer(ChannelInboundHandlerAdapter handler, int idle) {
        this.handler = handler;
        this.idle = idle;
    }

    @Override
    protected void initChannel(SocketChannel socketChannel) throws Exception {
        //添加消息处理器
        ChannelPipeline pipeline = socketChannel.pipeline();
        pipeline.addLast(new IdleStateHandler(idle, 0, 0));
        pipeline.addLast(new LittleIODecoder());
        pipeline.addLast(handler);
//        pipeline.addLast(new LittleIOEncoder());
        pipeline.addLast(new LittleMessageEncoder());
    }
}
