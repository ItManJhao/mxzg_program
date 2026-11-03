package com.ayjs.rpc.client;

/**
 * 异步操作
 *
 * @author Alias
 * @date 2018年1月10日 下午4:07:47
 */
public interface Future<T> {

    boolean cancel();

    boolean isCancelled();

    boolean isDone();

    boolean isSuccess();

    T get();

    Throwable cause();

    void addListener(FutureListener<T> listener);
}