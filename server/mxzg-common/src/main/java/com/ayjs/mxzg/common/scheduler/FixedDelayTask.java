package com.ayjs.mxzg.common.scheduler;

public class FixedDelayTask extends IntervalTask {

    /**
     * Create a new {@code FixedDelayTask}.
     *
     * @param identity     task identity
     * @param runnable     the underlying task to execute
     * @param interval     how often in milliseconds the task should be executed
     * @param initialDelay the initial delay before first execution of the task
     */
    public FixedDelayTask(Object identity, Runnable runnable, long interval, long initialDelay) {
        super(identity, runnable, interval, initialDelay);
    }

}
