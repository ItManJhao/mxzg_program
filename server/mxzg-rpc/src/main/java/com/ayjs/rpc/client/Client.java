package com.ayjs.rpc.client;

/**
 * 客户端
 * @author meiyc
 *
 * @param <T>
 */
public interface Client<T> {

    /**
     * 获取rpcClient
     *
     * @return
     */
    RpcClient rpcClient();

    /**
     * 启动客户端
     * @param host
     * @param port
     */
    void start(String host, int port);

    /**
     * 关闭客户端
     */
    void shutdown();

}
