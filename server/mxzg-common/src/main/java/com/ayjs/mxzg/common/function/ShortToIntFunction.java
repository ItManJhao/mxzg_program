package com.ayjs.mxzg.common.function;

/**
 *
 */
@FunctionalInterface
public interface ShortToIntFunction {

    /**
     * Applies this function to the given argument.
     *
     * @param value the function argument
     * @return the function result
     */
    int applyAsInt(short value);
}
