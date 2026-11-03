package com.ayjs.mxzg.common.scheduler;

import lombok.extern.slf4j.Slf4j;

import java.time.Duration;
import java.time.LocalDateTime;
import java.util.Objects;
import java.util.concurrent.RejectedExecutionException;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.ScheduledFuture;
import java.util.concurrent.TimeUnit;

@Slf4j
public class ThreadPoolTaskScheduler {

    private final ScheduledExecutorService executor;
    private final long threshold;
    private final ErrorHandler errorHandler;

    public ThreadPoolTaskScheduler(ScheduledExecutorService executor, long threshold) {
        this(executor, threshold, LoggingHandler.INSTANCE);
    }

    /**
     * 定时器
     *
     * @param executor
     * @param threshold    临界时间(单位: 毫秒), 当定时任务执行时间超过临界时间输出日志
     * @param errorHandler 错误处理
     */
    public ThreadPoolTaskScheduler(ScheduledExecutorService executor, long threshold, ErrorHandler errorHandler) {
        this.executor = Objects.requireNonNull(executor);
        if (threshold <= 0)
            throw new IllegalArgumentException();
        this.threshold = threshold;
        this.errorHandler = Objects.requireNonNull(errorHandler);
    }

    public ScheduledFuture<?> schedule(CronTask task) {
        try {
            ReschedulingRunnable reschedulingRunnable = new ReschedulingRunnable(task, executor, errorHandler);
            registerLoggingTriggerContextListener(reschedulingRunnable, task.getIdentity(), threshold);
            return reschedulingRunnable.schedule();
        } catch (RejectedExecutionException e) {
            throw new TaskRejectedException(String.format("Executor{%s} did not accept task{%s}", executor, task.getIdentity()), e);
        } catch (Exception e) {
            throw new RuntimeException(String.format("Executor{%s} schedule task{%s} failed", executor, task.getIdentity()), e);
        }
    }

    private void registerLoggingTriggerContextListener(ReschedulingRunnable runnable, Object identity, long threshold) {
        runnable.register(new TriggerContextListener() {
            @Override
            public void onUpdate(LocalDateTime lastScheduledExecutionTime, LocalDateTime lastActualExecutionTime, LocalDateTime lastCompletionTime) {
                if (lastActualExecutionTime != null && lastCompletionTime != null) {
                    Duration duration = Duration.between(lastActualExecutionTime, lastCompletionTime);
//                    long executeTime = lastCompletionTime.getTime() - lastActualExecutionTime.getTime();
                    if (duration.toMillis() > threshold) {
                        log.warn(String.format("Task{%s} execute %s ms", identity, duration.toMillis()));
                    }
                }
            }
        });
    }

    public ScheduledFuture<?> scheduleFixedDelayTask(IntervalTask task) {
        try {
            WrappedRunnable wrappedRunnable = new WrappedRunnable(task.getIdentity(), task.getRunnable(), threshold, errorHandler);
            return executor.scheduleWithFixedDelay(wrappedRunnable, task.getInitialDelay(), task.getInterval(), TimeUnit.MILLISECONDS);
        } catch (RejectedExecutionException e) {
            throw new TaskRejectedException(String.format("Executor{%s} did not accept task{%s}", executor, task.getIdentity()), e);
        } catch (Exception e) {
            throw new RuntimeException(String.format("Executor{%s} schedule task{%s} failed", executor, task.getIdentity()), e);
        }
    }

    public ScheduledFuture<?> schedule(Object identity, Runnable command, long delay, TimeUnit unit) {
        try {
            WrappedRunnable wrappedRunnable = new WrappedRunnable(identity == null ? "unknown" : identity, command, threshold, errorHandler);
            return executor.schedule(wrappedRunnable, delay, unit);
        } catch (RejectedExecutionException e) {
            throw new TaskRejectedException(String.format("Executor{%s} did not accept task{%s}", executor, identity), e);
        } catch (Exception e) {
            throw new RuntimeException(String.format("Executor{%s} schedule task{%s} failed", executor, identity), e);
        }
    }

    @Slf4j
    private enum LoggingHandler implements ErrorHandler {
        INSTANCE;

        @Override
        public void handleError(Throwable t) {
            if (log.isErrorEnabled()) {
                log.error("Unexpected error occurred in scheduled task.", t);
            }
        }
    }

    public void shutdown() {
        executor.shutdown();
    }
}
