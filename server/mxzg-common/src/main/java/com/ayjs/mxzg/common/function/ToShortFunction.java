package com.ayjs.mxzg.common.function;

/**
 *
 */
@FunctionalInterface
public interface ToShortFunction<T> {

    /**
     * Applies this function to the given argument.
     *
     * @param value the function argument
     * @return the function result
     */
    short applyAsShort(T value);
}
