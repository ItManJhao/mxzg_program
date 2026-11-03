package com.ayjs.mxzg.common.redis.pubsub;

/**
 * redis 发布订阅消息执行器
 */
public interface RedisMessageInvoker<T extends RedisMessage> {

    /**
     * 处理消息
     *
     * @param t
     */
    void invoke(T t);
}
