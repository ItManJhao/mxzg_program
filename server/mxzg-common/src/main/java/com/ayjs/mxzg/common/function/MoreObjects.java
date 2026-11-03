package com.ayjs.mxzg.common.function;

import java.util.function.Supplier;

/**
 *
 */
public class MoreObjects {

    /**
     * Returns the first of two given parameters that is not {@code null}, if either is, or otherwise
     * throws a {@link NullPointerException}.
     *
     * @param first
     * @param second
     * @param <T>
     * @return
     */
    public static <T> T firstNonNull(T first, Supplier<T> second) {
        if (first != null) {
            return first;
        }
        T val = second.get();
        if (val != null) {
            return val;
        }
        throw new NullPointerException("Both parameters are null");
    }

    /**
     * Returns the first of two given parameters that is not {@code null}, if either is, or otherwise
     * throws a {@link NullPointerException}.
     *
     * @param first
     * @param second
     * @param <T>
     * @return
     */
    public static <T> T firstNonNull(T first, T second) {
        if (first != null) {
            return first;
        }
        if (second != null) {
            return second;
        }
        throw new NullPointerException("Both parameters are null");
    }
}
