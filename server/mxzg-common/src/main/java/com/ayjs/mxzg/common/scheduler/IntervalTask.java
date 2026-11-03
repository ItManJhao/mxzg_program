package com.ayjs.mxzg.common.scheduler;

public class IntervalTask {

    private final Object identity;
    private final Runnable runnable;
    private final long interval;
    private final long initialDelay;

    /**
     * Create a new {@code IntervalTask}.
     *
     * @param identity     task identity
     * @param runnable     the underlying task to execute
     * @param interval     how often in milliseconds the task should be executed
     * @param initialDelay the initial delay before first execution of the task
     */
    public IntervalTask(Object identity, Runnable runnable, long interval, long initialDelay) {
        this.identity = identity;
        this.runnable = runnable;
        this.interval = interval;
        this.initialDelay = initialDelay;
    }

    /**
     * Create a new {@code IntervalTask} with no initial delay.
     *
     * @param identity task identity
     * @param runnable the underlying task to execute
     * @param interval how often in milliseconds the task should be executed
     */
    public IntervalTask(Object identity, Runnable runnable, long interval) {
        this(identity, runnable, interval, 0);
    }

    /**
     * Return task identity
     *
     * @return
     */
    public Object getIdentity() {
        return identity;
    }

    /**
     * Return the underlying task.
     */
    public Runnable getRunnable() {
        return runnable;
    }

    /**
     * Return how often in milliseconds the task should be executed.
     */
    public long getInterval() {
        return this.interval;
    }

    /**
     * Return the initial delay before first execution of the task.
     */
    public long getInitialDelay() {
        return this.initialDelay;
    }
}
