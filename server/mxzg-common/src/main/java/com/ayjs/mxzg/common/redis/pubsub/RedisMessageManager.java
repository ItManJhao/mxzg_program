package com.ayjs.mxzg.common.redis.pubsub;

import com.ayjs.mxzg.common.base.IRegister;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.TypeUtil;
import com.google.common.collect.Maps;
import org.springframework.stereotype.Component;

import java.util.Map;

/**
 * redis 发布订阅消息处理
 */
@Component
public class RedisMessageManager implements IRegister<RedisMessageInvoker<? extends RedisMessage>> {

    private final Map<Class<?>, RedisMessageInvoker<? extends RedisMessage>> invokerMap = Maps.newHashMap();

    @Override
    public void registerBean(RedisMessageInvoker<? extends RedisMessage> bean) {
        Class<?> clazz = resolveClass(bean);
        Asserts.isNull(invokerMap.putIfAbsent(clazz, bean), String.format("%s duplicated", bean));
    }

    private Class<?> resolveClass(RedisMessageInvoker<? extends RedisMessage> bean) {
        return TypeUtil.resolveClassArguments(bean.getClass(), RedisMessageInvoker.class)[0];
    }

    @SuppressWarnings("unchecked")
    private <T extends RedisMessage> RedisMessageInvoker<T> getInvoker(T message) {
        RedisMessageInvoker<T> invoker = (RedisMessageInvoker<T>) invokerMap.get(message.getClass());
        // 没有处理器的消息，使用默认处理器
        if (invoker == null) {
            invoker = (RedisMessageInvoker<T>) DefaultRedisMessageInvoker.INSTANCE;
        }
        return invoker;
    }

    public <T extends RedisMessage> void invoke(T message) {
        getInvoker(message).invoke(message);
    }
}
