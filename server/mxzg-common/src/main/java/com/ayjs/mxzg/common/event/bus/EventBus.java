package com.ayjs.mxzg.common.event.bus;

/**
 * 事件总线
 */
public interface EventBus {

    /**
     * 发布事件
     */
    <T> void post(T event);

    /**
     * 注册事件观察者
     */
    void register(Object observer);

    /**
     * 注销事件观察者
     */
    void unregister(Object observer);

    void printSubscriber();
}
