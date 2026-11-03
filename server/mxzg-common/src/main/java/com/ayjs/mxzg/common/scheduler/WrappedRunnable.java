package com.ayjs.mxzg.common.scheduler;

import lombok.extern.slf4j.Slf4j;

import java.util.Objects;

/**
 *
 */
@Slf4j
public class WrappedRunnable extends DelegatingErrorHandlingRunnable {

    private final Object identity;
    private final long threshold;

    public WrappedRunnable(Object identity, Runnable runnable, long threshold, ErrorHandler errorHandler) {
        super(runnable, errorHandler);
        this.identity = Objects.requireNonNull(identity);
        this.threshold = threshold;
    }

    @Override
    public void run() {
        long time = System.currentTimeMillis();
        super.run();
        long executeTime = System.currentTimeMillis() - time;
        if (executeTime > threshold) {
            log.warn(String.format("Task [%s] execute %s ms", identity, executeTime));
        }
    }
}
