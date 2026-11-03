package com.ayjs.mxzg.common.persistence.log.buffer;

import com.ayjs.mxzg.common.executor.OrderlyExecutorService;
import com.ayjs.mxzg.common.persistence.log.ILog;
import com.ayjs.mxzg.common.persistence.log.LogPersistence;
import com.ayjs.mxzg.common.util.gson.GsonUtils;
import lombok.extern.slf4j.Slf4j;

import java.util.ArrayList;
import java.util.List;
import java.util.Objects;
import java.util.Queue;
import java.util.concurrent.LinkedBlockingQueue;
import java.util.concurrent.ThreadLocalRandom;
import java.util.concurrent.TimeUnit;

/**
 * 延迟日志缓冲
 */
@Slf4j
public class DelayedLogBuffer<T extends ILog> implements LogBuffer<T> {
    /**
     * 持久化服务
     */
    private final LogPersistence<T> persistence;
    /**
     * 持久化线程池
     */
    private final OrderlyExecutorService executorService;
    /** 最大缓冲数量 */
    private final int maxBufferSize;
    /** 缓冲清空间隔 */
    private final long flushPeriod;
    /** 批量添加个数 */
    private final int batchAddSize;
    /** 待落地的日志缓存 */
    private final LinkedBlockingQueue<T> adds = new LinkedBlockingQueue<>();

    public DelayedLogBuffer(LogPersistence<T> persistence, OrderlyExecutorService executorService,
                            int maxBufferSize, long flushPeriod, int batchAddSize) {
        if (maxBufferSize <= 0 || flushPeriod <= 0 || batchAddSize <= 0)
            throw new IllegalArgumentException();
        this.persistence = Objects.requireNonNull(persistence);
        this.executorService = Objects.requireNonNull(executorService);
        this.maxBufferSize = maxBufferSize;
        this.flushPeriod = flushPeriod;
        this.batchAddSize = batchAddSize;
        this.schedule();
    }

    @Override
    public void add(T entity) {
        adds.add(entity);
        if (adds.size() >= maxBufferSize) {
            executeFlushTask();
        }
    }

    @Override
    public void flush() {
        if (!DelayedLogBufferExecutor.INSTANCE.isShutdown()) {
            DelayedLogBufferExecutor.INSTANCE.execute(() -> {
                if (log.isDebugEnabled()) {
                    log.debug("flush ... {}", persistence);
                }
                flush(adds);
            });
        } else {
            log.error("DelayedLogBuffer flush .DelayedLogBufferExecutor.INSTANCE.isShutdown() is true...persistence:{}",
                    GsonUtils.toJson(persistence));
        }
    }

    private void schedule() {
        int random = ThreadLocalRandom.current().nextInt((int) flushPeriod);
        DelayedLogBufferExecutor.INSTANCE.scheduleAtFixedRate(() -> {
            if (!adds.isEmpty()) {
                if (log.isDebugEnabled()) {
                    log.debug("schedule flush task. {}", persistence);
                }
                flush(adds);
            }
        }, flushPeriod + random, flushPeriod, TimeUnit.MILLISECONDS);
    }

    private void executeFlushTask() {
        DelayedLogBufferExecutor.INSTANCE.execute(() -> {
            if (adds.size() >= maxBufferSize) {
                if (log.isDebugEnabled()) {
                    log.debug("execute flush task. {}", persistence);
                }
                flush(adds);
            }
        });
    }

    private void flush(Queue<T> pending) {
        int count = 0;
        T entity;
        List<T> batch = newBatchAddList();
        while ((entity = pending.poll()) != null) {
            if (batch.size() == batchAddSize) {
                batchAddImmediately(batch);
                batch = newBatchAddList();
            }
            batch.add(entity);
            ++count;
        }
        if (!batch.isEmpty()) {
            batchAddImmediately(batch);
        }
        if (log.isDebugEnabled()) {
            log.debug("flush count: {}, {}", count, persistence);
        }
    }

    private List<T> newBatchAddList() {
        return new ArrayList<>(batchAddSize);
    }

    private void batchAddImmediately(List<T> entities) {
        executorService.hashOrRandom(this).execute(() -> {
            try {
                persistence.batchAdd(entities);
            } catch (Exception e) {
                log.error("插入数据异常", e);
            }
        });
    }
}
