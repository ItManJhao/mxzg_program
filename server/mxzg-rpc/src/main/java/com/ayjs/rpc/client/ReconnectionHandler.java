package com.ayjs.rpc.client;


import com.ayjs.rpc.HeartbeatMessage;
import io.netty.bootstrap.Bootstrap;
import io.netty.channel.ChannelFuture;
import io.netty.channel.ChannelFutureListener;
import io.netty.channel.ChannelHandlerContext;
import io.netty.channel.ChannelInboundHandlerAdapter;
import lombok.extern.slf4j.Slf4j;

import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

/**
 * 抽象的自动重连客户端
 */
@Slf4j
public class ReconnectionHandler extends ChannelInboundHandlerAdapter {

    /**
     * 当前客户端
     */
    private Bootstrap bootstrap;
    /**
     * 心跳消息
     */
    private HeartbeatMessage heartbeatMessage = HeartbeatMessage.getInstance();
    /**
     * 调度器
     */
    private ScheduledExecutorService executorService = Executors.newScheduledThreadPool(1);

    public ReconnectionHandler(Bootstrap bootstrap) {
        this.bootstrap = bootstrap;
    }


    @Override
    public void channelInactive(ChannelHandlerContext ctx) throws Exception {
        executorService.schedule(() -> {
            try {
                run();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }, 3000, TimeUnit.MILLISECONDS);
//        ctx.fireChannelInactive();
        super.channelInactive(ctx);
    }

    public void run() throws Exception {
        ChannelFuture future = this.bootstrap.connect();
        future.addListener(new ChannelFutureListener() {
            public void operationComplete(ChannelFuture f) throws Exception {
                boolean succeed = f.isSuccess();
                //如果重连失败，则调用ChannelInactive方法，再次出发重连事件，一直尝试12次，如果失败则不再重连
                if (!succeed) {
                    System.out.println("重连失败");
                    f.channel().pipeline().fireChannelInactive();
                } else {
                    System.out.println("重连成功");
                }
            }
        });
    }
}

