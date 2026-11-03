package com.ayjs.mxzg.common.persistence.log.buffer;

import com.ayjs.mxzg.common.executor.OrderlyExecutorService;
import com.ayjs.mxzg.common.persistence.log.ILog;
import com.ayjs.mxzg.common.persistence.log.LogPersistence;
import com.ayjs.mxzg.common.util.gson.GsonUtils;
import lombok.extern.slf4j.Slf4j;

import java.util.Objects;
import java.util.concurrent.TimeUnit;

/**
 * 异步
 */
@Slf4j
public class AsyncLogBuffer<T extends ILog> implements LogBuffer<T> {
    /**
     * 持久化服务
     */
    private final LogPersistence<T> persistence;
    /**
     * 持久化线程池
     */
    private final OrderlyExecutorService executorService;

    public AsyncLogBuffer(LogPersistence<T> persistence, OrderlyExecutorService executorService) {
        this.persistence = Objects.requireNonNull(persistence);
        this.executorService = Objects.requireNonNull(executorService);
    }

    @Override
    public void add(T entity) {
        executorService.hashOrRandom(this).execute(() -> {
            try {
                persistence.add(entity);
            } catch (Exception e) {
                log.error(String.format("插入数据 %s=%s 异常", entity.getClass().getSimpleName(), GsonUtils.toJson(entity)), e);
            }
        });
    }

    @Override
    public void shutdown() {
        if (executorService != null) {
            executorService.shutdown();
            int count = 0;
            try {
                while (!executorService.awaitTermination(5, TimeUnit.SECONDS)) {
                    log.info("executorService await termination {}", ++count);
                }
            } catch (InterruptedException e) {
                e.printStackTrace();
                throw new RuntimeException(e);
            }

            log.info("executorService closed");
        }

    }
}
