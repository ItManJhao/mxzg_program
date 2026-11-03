package com.ayjs.rpc.client;

/**
 * 监听器
 *
 * @author Alias
 * @date 2018年1月10日 下午4:06:22
 */
public interface FutureListener<T> {

    void operationComplete(Future<T> future) throws Exception;
}