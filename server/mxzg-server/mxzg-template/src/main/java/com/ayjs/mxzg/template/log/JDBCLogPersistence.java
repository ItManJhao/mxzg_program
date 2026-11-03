package com.ayjs.mxzg.template.log;


import com.ayjs.mxzg.common.persistence.log.AbstractLog;
import com.ayjs.mxzg.common.persistence.log.BaseLogRepository;
import com.ayjs.mxzg.common.persistence.log.LogPersistence;

import java.util.List;

/**
 * 数据库持久化
 */
public class JDBCLogPersistence<T extends AbstractLog> implements LogPersistence<T> {

    private final BaseLogRepository<T> repository;

    public JDBCLogPersistence(BaseLogRepository<T> repository) {
        this.repository = repository;
    }

    @Override
    public void add(T entity) {
        repository.add(entity);
    }

    @Override
    public void batchAdd(List<T> entities) {
        repository.add(entities);
    }

    @Override
    public String toString() {
        return "JDBCLogPersistence{" +
                "name=" + repository.getClass().getSimpleName() +
                '}';
    }
}
