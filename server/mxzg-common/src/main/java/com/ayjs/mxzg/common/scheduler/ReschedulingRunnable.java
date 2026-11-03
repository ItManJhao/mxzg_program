package com.ayjs.mxzg.common.scheduler;

import com.ayjs.mxzg.common.util.time.LocalDateTimeUtil;

import java.time.LocalDateTime;
import java.util.LinkedHashSet;
import java.util.Objects;
import java.util.Set;
import java.util.concurrent.Delayed;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.ScheduledFuture;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.TimeoutException;

public class ReschedulingRunnable extends DelegatingErrorHandlingRunnable implements Runnable, ScheduledFuture<Object>, TriggerContextListener {

    private final CronTrigger trigger;
    private final TriggerContext triggerContext;
    private final ScheduledExecutorService executor;
    private final Object triggerContextMonitor = new Object();
    private ScheduledFuture<?> currentFuture;
    private LocalDateTime scheduledExecutionTime;
    private Set<TriggerContextListener> listeners = new LinkedHashSet<>();

    public ReschedulingRunnable(CronTask task, ScheduledExecutorService executor, ErrorHandler errorHandler) {
        super(task.getRunnable(), errorHandler);
        this.trigger = task.getTrigger();
        this.triggerContext = new TriggerContext(
                task.getLastScheduledExecutionTime(),
                task.getLastActualExecutionTime(),
                task.getLastCompletionTime());
        this.executor = executor;
        register(task.getListener());
    }

    public ScheduledFuture<?> schedule() {
        synchronized (this.triggerContextMonitor) {
            this.scheduledExecutionTime = this.trigger.nextExecutionTime(this.triggerContext);
            onDetermineNextExecutionTime(this.scheduledExecutionTime);
            long initialDelay = LocalDateTimeUtil.toEpochMilli(this.scheduledExecutionTime) - System.currentTimeMillis();
            this.currentFuture = this.executor.schedule(this, initialDelay, TimeUnit.MILLISECONDS);
            return this;
        }
    }

    public void register(TriggerContextListener listener) {
        Objects.requireNonNull(listener);
        listeners.add(listener);
    }

    private ScheduledFuture<?> obtainCurrentFuture() {
        return this.currentFuture;
    }

    @Override
    public void run() {
        LocalDateTime actualExecutionTime = LocalDateTime.now();
        super.run();
        LocalDateTime completionTime = LocalDateTime.now();
        synchronized (this.triggerContextMonitor) {
            LocalDateTime lastScheduledExecutionTime = this.scheduledExecutionTime;
            this.triggerContext.update(lastScheduledExecutionTime, actualExecutionTime, completionTime);
            onUpdate(lastScheduledExecutionTime, actualExecutionTime, completionTime);
            if (!obtainCurrentFuture().isCancelled()) {
                schedule();
            }
        }
    }

    @Override
    public void onDetermineNextExecutionTime(LocalDateTime nextExecutionTime) {
        listeners.forEach(listener -> listener.onDetermineNextExecutionTime(nextExecutionTime));
    }

    @Override
    public void onUpdate(LocalDateTime lastScheduledExecutionTime, LocalDateTime lastActualExecutionTime, LocalDateTime lastCompletionTime) {
        listeners.forEach(listener ->
                listener.onUpdate(lastScheduledExecutionTime, lastActualExecutionTime, lastCompletionTime));
    }

    @Override
    public boolean cancel(boolean mayInterruptIfRunning) {
        synchronized (this.triggerContextMonitor) {
            return obtainCurrentFuture().cancel(mayInterruptIfRunning);
        }
    }

    @Override
    public boolean isCancelled() {
        synchronized (this.triggerContextMonitor) {
            return obtainCurrentFuture().isCancelled();
        }
    }

    @Override
    public boolean isDone() {
        synchronized (this.triggerContextMonitor) {
            return obtainCurrentFuture().isDone();
        }
    }

    @Override
    public Object get() throws InterruptedException, ExecutionException {
        ScheduledFuture<?> curr;
        synchronized (this.triggerContextMonitor) {
            curr = obtainCurrentFuture();
        }
        return curr.get();
    }

    @Override
    public Object get(long timeout, TimeUnit unit) throws InterruptedException, ExecutionException, TimeoutException {
        ScheduledFuture<?> curr;
        synchronized (this.triggerContextMonitor) {
            curr = obtainCurrentFuture();
        }
        return curr.get(timeout, unit);
    }

    @Override
    public long getDelay(TimeUnit unit) {
        ScheduledFuture<?> curr;
        synchronized (this.triggerContextMonitor) {
            curr = obtainCurrentFuture();
        }
        return curr.getDelay(unit);
    }

    @Override
    public int compareTo(Delayed other) {
        if (this == other) {
            return 0;
        }
        long diff = getDelay(TimeUnit.MILLISECONDS) - other.getDelay(TimeUnit.MILLISECONDS);
        return (diff == 0 ? 0 : ((diff < 0) ? -1 : 1));
    }

}
