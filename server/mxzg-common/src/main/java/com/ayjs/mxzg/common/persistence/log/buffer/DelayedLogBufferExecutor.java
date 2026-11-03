package com.ayjs.mxzg.common.persistence.log.buffer;

import com.ayjs.mxzg.common.util.NamesThreadFactory;
import lombok.extern.slf4j.Slf4j;

import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

/**
 * 缓冲清空定时器
 */
@Slf4j
public enum DelayedLogBufferExecutor {

    INSTANCE;

    private final ScheduledExecutorService executor =
            Executors.newSingleThreadScheduledExecutor(new NamesThreadFactory("DELAYED LOG BUFFER FLUSH EXECUTOR"));

    public void scheduleAtFixedRate(Runnable command, long initialDelay, long period, TimeUnit unit) {
        executor.scheduleAtFixedRate(command, initialDelay, period, unit);
    }

    public void execute(Runnable command) {
        executor.execute(command);
    }

    public void shutdown() throws InterruptedException {
        executor.shutdown();
        log.info("handing caching tasks ...");
        int count = 0;
        while (!executor.awaitTermination(5, TimeUnit.SECONDS)) {
            log.info("await termination {}", ++count);
        }
        log.info("handing caching tasks over");
    }

    public boolean isShutdown() {
        return executor.isShutdown();
    }
}
