package com.ayjs.mxzg.common.persistence.log.buffer;

import com.ayjs.mxzg.common.persistence.log.ILog;

/**
 * 日志缓存
 */
public interface LogBuffer<T extends ILog> {
    /**
     * 添加日志
     *
     * @param entity
     */
    void add(T entity);

    /**
     * 缓冲清空
     */
    default void flush() {
    }

    default void shutdown() {
    }

}
