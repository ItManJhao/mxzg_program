package com.ayjs.mxzg.common.redis.pubsub;

/**
 * redis 消息发布订阅频道
 */
public abstract class RedisChannelTopic {
    /**
     * 频道命名规则，模块：范围
     * 例如：chat:all 聊天所有服处理此消息
     */
    public static final String CHAT_ALL = "chat:all";
}
