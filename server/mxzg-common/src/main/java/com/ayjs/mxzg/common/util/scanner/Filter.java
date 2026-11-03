package com.ayjs.mxzg.common.util.scanner;

/**
 * 过滤
 */
@FunctionalInterface
public interface Filter<T> {

    /**
     * 接收条件
     *
     * @return true-条件满足
     */
    boolean accept(T object);
}
