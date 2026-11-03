package com.ayjs.mxzg.common.function;

import java.util.concurrent.atomic.AtomicBoolean;
import java.util.concurrent.atomic.AtomicLong;
import java.util.function.IntConsumer;
import java.util.function.LongConsumer;

/**
 *
 */
public class AtomicLongSummaryStatistics implements LongConsumer, IntConsumer {

    private final AtomicLong count = new AtomicLong();
    private final AtomicLong sum = new AtomicLong();
    private final AtomicLong min = new AtomicLong();
    private final AtomicLong max = new AtomicLong();

    private final AtomicBoolean lock = new AtomicBoolean(false);

    private boolean tryLock() {
        return lock.compareAndSet(false, true);
    }

    private void unlock() {
        lock.compareAndSet(true, false);
    }

    @Override
    public void accept(int value) {
        accept((long) value);
    }

    @Override
    public void accept(long value) {
        for (; ; ) {
            if (tryLock()) {
                try {
                    count.incrementAndGet();
                    sum.addAndGet(value);
                    min.getAndUpdate(val -> Math.min(val, value));
                    max.getAndUpdate(val -> Math.max(val, value));
                    return;
                } finally {
                    unlock();
                }
            }
        }
    }

    public void combine(AtomicLongSummaryStatistics other) {
        for (; ; ) {
            if (tryLock()) {
                try {
                    count.addAndGet(other.count.get());
                    sum.addAndGet(other.sum.get());
                    min.getAndUpdate(val -> Math.min(val, other.min.get()));
                    max.getAndUpdate(val -> Math.max(val, other.max.get()));
                    return;
                } finally {
                    unlock();
                }
            }
        }
    }

    public final long getCount() {
        return count.get();
    }

    public final long getSum() {
        return sum.get();
    }

    public final long getMin() {
        return min.get();
    }

    public final long getMax() {
        return max.get();
    }

    public final double getAverage() {
        for (; ; ) {
            long count;
            long sum;
            if (tryLock()) {
                try {
                    count = getCount();
                    sum = getSum();
                } finally {
                    unlock();
                }
                return computeAverage(sum, count);
            }
        }
    }

    private double computeAverage(double sum, long count) {
        return count > 0L ? sum / count : 0.0d;
    }

    public String message() {
        for (; ; ) {
            long count;
            long sum;
            long min;
            long max;
            if (tryLock()) {
                try {
                    count = getCount();
                    sum = getSum();
                    min = getMin();
                    max = getMax();
                } finally {
                    unlock();
                }
                double average = computeAverage(sum, count);
                return String.format(
                        "{count=%d, sum=%d, min=%d, average=%f, max=%d}",
                        count,
                        sum,
                        min,
                        average,
                        max);
            }
        }
    }
}
