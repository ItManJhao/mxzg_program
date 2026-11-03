package com.ayjs.mxzg.common.executor;

import java.util.concurrent.ExecutorService;
import java.util.concurrent.TimeUnit;

/**
 * 有序执行器服务
 */
public interface OrderlyExecutorService {

    /**
     * 根据key的hash值跟执行器组的size取模，用余数来获取执行器
     * 如果key == null 则根据执行器组的size随机一个执行器
     *
     * @param key
     * @return
     */
    ExecutorService hashOrRandom(Object key);

    /**
     * 关闭执行器组
     */
    void shutdown();

    /**
     * 等待任务终止
     *
     * @param timeout
     * @param timeUnit
     * @return
     * @throws InterruptedException
     */
    boolean awaitTermination(long timeout, TimeUnit timeUnit) throws InterruptedException;
}
