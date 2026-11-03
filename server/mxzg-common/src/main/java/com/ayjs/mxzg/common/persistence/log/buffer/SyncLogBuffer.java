package com.ayjs.mxzg.common.persistence.log.buffer;

import com.ayjs.mxzg.common.persistence.log.ILog;
import com.ayjs.mxzg.common.persistence.log.LogPersistence;
import com.ayjs.mxzg.common.util.gson.GsonUtils;
import lombok.extern.slf4j.Slf4j;

/**
 * 同步处理
 */
@Slf4j
public class SyncLogBuffer<T extends ILog> implements LogBuffer<T> {
    /**
     * 持久化服务
     */
    private final LogPersistence<T> persistence;

    public SyncLogBuffer(LogPersistence<T> persistence) {
        this.persistence = persistence;
    }

    @Override
    public void add(T entity) {
        try {
            persistence.add(entity);
        } catch (Exception e) {
            log.error(String.format("插入数据 %s=%s 异常", entity.getClass().getSimpleName(), GsonUtils.toJson(entity)), e);
        }
    }
}
