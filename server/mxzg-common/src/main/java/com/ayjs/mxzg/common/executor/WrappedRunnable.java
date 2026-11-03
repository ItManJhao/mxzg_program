package com.ayjs.mxzg.common.executor;

import com.ayjs.mxzg.common.util.MethodCalledStatistic;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

/**
 *
 */
public abstract class WrappedRunnable implements Runnable {

    private static final Log log = LogFactory.getLog(WrappedRunnable.class);

    /*
     * 临界时间
     */
    private final long threshold;

    protected WrappedRunnable(long threshold) {
        this.threshold = threshold;
    }

    protected WrappedRunnable() {
        this(100);
    }

    @Override
    public void run() {
        long time = System.currentTimeMillis();
        try {
            execute();
        } catch (Exception e) {
            log.error("execute runnable error", e);
        } finally {
            time = System.currentTimeMillis() - time;
            MethodCalledStatistic.handleStats(this.getClass(), "run", time);
            if (time > threshold) {
                log.warn(this + ".Run:" + time + "ms.");
            }
        }
    }

    /**
     * 执行一个任务
     */
    protected abstract void execute();

    @Override
    public String toString() {
        return this.getClass().getName();
    }
}
