package com.ayjs.mxzg.common.redis.pubsub;

import lombok.extern.slf4j.Slf4j;

/**
 * 默认消息处理器
 *
 * @author tangyangbo created at 2018/8/24 下午2:49
 */
@Slf4j
public class DefaultRedisMessageInvoker implements RedisMessageInvoker<RedisMessage> {

    public static final DefaultRedisMessageInvoker INSTANCE = new DefaultRedisMessageInvoker();

    @Override
    public void invoke(RedisMessage redisMessage) {
        log.info("unregistered {}", redisMessage);
    }
}
