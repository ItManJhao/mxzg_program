package com.ayjs.mxzg.common.persistence.generator;

import com.ayjs.mxzg.common.util.MathUtils;
import com.google.common.base.Preconditions;

import java.util.concurrent.atomic.AtomicLong;

/**
 * Long ID 生成器
 */
public class LongIdGenerator implements IdGenerator {
    private final int serverId;
    private final AtomicLong generator;

    private LongIdGenerator(int serverId, AtomicLong generator) {
        this.serverId = serverId;
        this.generator = generator;
    }

    public static LongIdGenerator of(int serverId, int initialIncrementDigit) {
        Preconditions.checkArgument(serverId > 0, "serverId{} cannot be negative", serverId);
        Preconditions.checkArgument(initialIncrementDigit > 0, "initialIncrementDigit{} cannot be negative", initialIncrementDigit);
        long originId = generateOriginId(serverId, initialIncrementDigit);
        Preconditions.checkState(originId > 0, "generateOriginId error");
        AtomicLong generator = new AtomicLong(originId);
        return new LongIdGenerator(serverId, generator);
    }

    public static LongIdGenerator of(long initialValue, int serverId, int initialIncrementDigit) {
        Preconditions.checkArgument(initialValue > 0, "initialValue{} cannot be negative", initialValue);
        Preconditions.checkArgument(serverId > 0, "serverId{} cannot be negative", serverId);
        Preconditions.checkArgument(initialIncrementDigit > 0, "initialIncrementDigit{} cannot be negative", initialIncrementDigit);

        Preconditions.checkState(serverId == MathUtils.getHeadNumBy(initialValue, serverId), String.format("initialValue{%s} no match serverId{%s}", initialValue, serverId));

        int serverIdLength = MathUtils.length(serverId);
        int expandDigit = initialIncrementDigit - (MathUtils.length(initialValue) - serverIdLength);
        AtomicLong generator;
        if (expandDigit > 0)
            generator = new AtomicLong(MathUtils.expand(initialValue, serverIdLength, expandDigit));
        else
            generator = new AtomicLong(initialValue);
        return new LongIdGenerator(serverId, generator);
    }

    /**
     * 生成自增长起始id
     *
     * @param serverId
     * @param exponent
     * @return
     */
    private static long generateOriginId(int serverId, int exponent) {
        return (long) (serverId * Math.pow(10, exponent));
    }

    @Override
    public Long nextId() {
        long nextId, oldVal;
        do {
            oldVal = generator.get();
            nextId = oldVal + 1;
            if (overflow(nextId)) {
                synchronized (this) {
                    if (overflow(nextId)) {
                        expand();
                    }
                }
                oldVal = generator.get();
                nextId = oldVal + 1;
            }
        } while (!generator.compareAndSet(oldVal, nextId));
        return nextId;
    }

    private void expand() {
        int beginIndex = MathUtils.length(serverId);
        long value, oldVal;
        do {
            oldVal = generator.get();
            value = MathUtils.expand(oldVal, beginIndex, 1);
            if (value <= 0)
                throw new RuntimeException(String.format("id{%s} reach the maximum", oldVal));
        } while (!generator.compareAndSet(oldVal, value));
    }

    private boolean overflow(long value) {
        return serverId != MathUtils.getHeadNumBy(value, serverId);
    }
}
