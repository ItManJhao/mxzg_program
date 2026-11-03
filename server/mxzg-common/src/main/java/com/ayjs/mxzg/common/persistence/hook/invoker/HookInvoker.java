package com.ayjs.mxzg.common.persistence.hook.invoker;

/**
 * 钩子调用者
 *
 * @param <T>
 */
public interface HookInvoker<T> {

    /**
     * 调用钩子并返回 {@code entity} 是否有修改
     *
     * @param entity
     * @return
     */
    boolean invoke(T entity);
}
