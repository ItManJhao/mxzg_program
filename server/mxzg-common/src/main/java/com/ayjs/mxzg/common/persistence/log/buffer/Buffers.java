package com.ayjs.mxzg.common.persistence.log.buffer;

import com.ayjs.mxzg.common.executor.OrderlyExecutorService;
import com.ayjs.mxzg.common.persistence.log.ILog;
import com.ayjs.mxzg.common.persistence.log.LogPersistence;

/**
 * 缓冲
 */
public class Buffers {

    /**
     * 同步缓冲
     *
     * @param persistence 持久化服务
     * @return
     */
    public static <T extends ILog> LogBuffer<T> newSyncLogBuffer(LogPersistence<T> persistence) {
        return new SyncLogBuffer<>(persistence);
    }

    /**
     * 异步缓冲
     *
     * @param persistence     持久化服务
     * @param executorService 持久化线程池
     * @return
     */
    public static <T extends ILog> LogBuffer<T> newAsyncLogBuffer(LogPersistence<T> persistence,
                                                                  OrderlyExecutorService executorService) {
        return new AsyncLogBuffer<>(persistence, executorService);
    }

    /**
     * 延时缓冲
     *
     * @param persistence     持久化服务
     * @param executorService 持久化线程池
     * @param maxBufferSize   最大缓冲数量, 达到时缓冲清空
     * @param flushPeriod     定时器的缓冲清空时间间隔(单位: 毫秒)
     * @param batchAddSize    批量添加个数
     * @return
     */
    public static <T extends ILog> LogBuffer<T> newDelayedLogBuffer(LogPersistence<T> persistence,
                                                                    OrderlyExecutorService executorService,
                                                                    int maxBufferSize,
                                                                    long flushPeriod,
                                                                    int batchAddSize) {
        return new DelayedLogBuffer<>(persistence, executorService, maxBufferSize, flushPeriod, batchAddSize);
    }
}
