package com.ayjs.mxzg.common.event.bus;

import com.ayjs.mxzg.common.event.subscriber.SubscriberRegistry;
import com.ayjs.mxzg.common.util.gson.GsonUtils;
import lombok.extern.slf4j.Slf4j;

import java.util.Objects;
import java.util.concurrent.Executor;

/**
 * 事件总线 executor 执行器 threshold 警告阈值(单位毫秒)，大于0 才生效
 */
@Slf4j
public class EventBusImpl implements EventBus {

    private final SubscriberRegistry subscriberRegistry;
    private final long threshold;

    public EventBusImpl(Executor executor, Executor logExecutor, long threshold) {
        this.subscriberRegistry = new SubscriberRegistry(executor, logExecutor);
        if (threshold < 0) {
            threshold = 0;
        }
        this.threshold = threshold;
    }

    @Override
    public <T> void post(T event) {
        Objects.requireNonNull(event);
        if (log.isDebugEnabled()) {
            log.debug("post event:{},context:{}", event.getClass().getSimpleName(), GsonUtils.toJson(event));
        }
        dispatch(event);
    }

    @Override
    public void register(Object observer) {
        subscriberRegistry.register(observer);
    }

    @Override
    public void unregister(Object observer) {
        subscriberRegistry.unregister(observer);
    }

    private <T> void dispatch(T event) {
        subscriberRegistry.streamSubscriber(event).forEach(subscriber -> subscriber.dispatch(event, threshold));
    }

    @Override
    public void printSubscriber() {
        subscriberRegistry.printSubscriberMap();
    }
}
