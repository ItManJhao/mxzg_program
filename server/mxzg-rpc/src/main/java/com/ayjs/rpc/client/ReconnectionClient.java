package com.ayjs.rpc.client;


import com.ayjs.rpc.HeartbeatMessage;
import io.netty.channel.ChannelFuture;
import io.netty.channel.ChannelFutureListener;
import lombok.extern.slf4j.Slf4j;

import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicReference;

/**
 * 自动重连客户端
 */
@Slf4j
public class ReconnectionClient extends RpcClient {

    /** 关闭客户端 */
    private AtomicReference<Boolean> shutdown = new AtomicReference<>(false);
    /** 心跳消息 */
    private HeartbeatMessage heartbeatMessage = HeartbeatMessage.getInstance();
    /** 调度器 */
    private ScheduledExecutorService executorService = Executors.newScheduledThreadPool(1);

    private ReconnectionClient(String host, int port) {
        super(host, port);
    }

    /**
     * 创建客户端
     *
     * @param host
     * @param port
     */
    protected static ReconnectionClient createAndStart(String host, int port) {
        ReconnectionClient client = new ReconnectionClient(host, port);
        client.start();
        client.autoConnect();
        return client;
    }


    /**
     * 客户端重连
     *
     */
    private void reconnection() {
        ChannelFuture future = connect();
        future.addListener(new ChannelFutureListener() {
            public void operationComplete(ChannelFuture f) throws Exception {
                try {
                    boolean succeed = f.isSuccess();
                    setChannel(f.channel());
                    if (succeed) {
                        log.info("远程服务器{}:{}连接成功!", getHost(), getPort());
                    } else {
                        log.info("远程服务器{}:{}连接失败!", getHost(), getPort());
                    }
                } finally {
                    autoConnect();
                }
            }
        });
    }

    /**
     * 自动连接客户端
     */
    private void autoConnect(){
        if(this.shutdown.get()){
            this.close();
           return;
        }

        executorService.schedule(() -> {
            if (channelIsActive()) {
                send(heartbeatMessage);
                autoConnect();
            } else {
                reconnection();
            }
        }, 3000, TimeUnit.MILLISECONDS);
    }

    /**
     * 关闭自动重连
     */
    public void shutdown(){
        this.shutdown.set(true);
        this.close();
    }
}
