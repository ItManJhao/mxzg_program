package com.ayjs.mxzg.common.function;

/**
 *
 */
@FunctionalInterface
public interface ShortFunction<R> {

    /**
     * Applies this function to the given argument.
     *
     * @param value the function argument
     * @return the function result
     */
    R apply(short value);
}
