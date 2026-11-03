package com.ayjs.rpc.client;

/**
 * 服务器主动推送的消息处理器
 *
 * @author Alias
 * @date 2017年12月12日 下午4:00:12
 */
public interface MessageHandler<T> {

    void handle(T message);
}
