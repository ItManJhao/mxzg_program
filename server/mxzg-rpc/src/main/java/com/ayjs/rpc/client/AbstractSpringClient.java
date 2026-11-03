package com.ayjs.rpc.client;

import java.util.concurrent.atomic.AtomicReference;

/**
 * 抽象的Spring代理客户端，用来支持注入的包装
 *
 * @param <T>
 */
public abstract class AbstractSpringClient<T> implements Client<T> {

    /**
     * 客户端
     */
    private AtomicReference<ReconnectionClient> clientRef = new AtomicReference<>();

    @Override
    public RpcClient rpcClient() {
        return clientRef.get();
    }

    @Override
    public void start(String host, int port) {
        ReconnectionClient client = ReconnectionClient.createAndStart(host, port);
        ReconnectionClient previousClient = this.clientRef.getAndSet(client);
        if(previousClient != null){
            previousClient.shutdown();
        }
    }


    /**
     * 关闭客户端
     */
    @Override
    public void shutdown() {
        ReconnectionClient client = clientRef.get();
        if (client != null) {
            client.shutdown();
        }
    }


    /**
     * 客户端是否连接中
     */
    public boolean isConnecting() {
        RpcClient rpcClient = clientRef.get();
        if (rpcClient != null && rpcClient.channelIsActive()) {
            return true;
        }
        return false;
    }

    /**
     * 是否是指定的服务器并且链接状态
     *
     * @param ip
     * @param port
     * @return
     */
    public boolean isSameServer(String ip, int port) {
        RpcClient rpcClient = rpcClient();
        if (rpcClient == null) {
            return false;
        }
        return ip.equals(rpcClient.getHost()) && port == rpcClient.getPort();
    }

}
