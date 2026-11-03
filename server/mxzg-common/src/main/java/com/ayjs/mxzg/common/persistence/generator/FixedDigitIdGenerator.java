package com.ayjs.mxzg.common.persistence.generator;

import com.google.common.base.Preconditions;

import java.util.concurrent.atomic.AtomicInteger;

/**
 * 固定数字长度ID生成器
 */
public class FixedDigitIdGenerator implements IdGenerator {

    private final AtomicInteger generator;
    private final int maxValue;

    private FixedDigitIdGenerator(AtomicInteger generator, int maxValue) {
        this.generator = generator;
        this.maxValue = maxValue;
    }

    public static FixedDigitIdGenerator of(int initialValue, int digit) {
        Preconditions.checkArgument(initialValue >= 0, "initialValue{} cannot be negative", digit);
        Preconditions.checkArgument(digit >= 0, "digit{} cannot be negative", digit);
        int maxValue = (int) Math.pow(10, digit) - 1;
        Preconditions.checkState(initialValue <= maxValue, "initialValue{%s} is greater than maxValue{%s}", initialValue, maxValue);
        return new FixedDigitIdGenerator(new AtomicInteger(initialValue), maxValue);
    }

    @Override
    public Integer nextId() {
        int nextId, oldVal;
        do {
            oldVal = generator.get();
            nextId = oldVal + 1;
            if (overflow(nextId, maxValue)) {
                throw new RuntimeException(String.format("id{%s} reach the maximum", generator.get()));
            }
        } while (!generator.compareAndSet(oldVal, nextId));
        return nextId;
    }

    private boolean overflow(int value, int maxValue) {
        return value > maxValue;
    }
}