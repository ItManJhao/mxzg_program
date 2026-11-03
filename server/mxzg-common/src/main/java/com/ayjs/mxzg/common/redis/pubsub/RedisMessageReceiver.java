package com.ayjs.mxzg.common.redis.pubsub;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * redis 消息处理
 */
@Service
@Slf4j
public class RedisMessageReceiver {

    @Autowired
    private RedisMessageManager redisMessageManager;

    public void handleMessage(Object message) {
        if (message instanceof RedisMessage)
            redisMessageManager.invoke((RedisMessage) message);
    }
}
