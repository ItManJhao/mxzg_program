package com.ayjs.mxzg.common.persistence.log;

import java.util.List;

/**
 * 持久化服务
 */
public interface LogPersistence<T extends ILog> {

    /**
     * 添加实体
     *
     * @param entity
     */
    void add(T entity);

    /**
     * 批量添加实体
     *
     * @param entities
     */
    void batchAdd(List<T> entities);
}
