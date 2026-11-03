package com.ayjs.mxzg.template.log;

import com.ayjs.mxzg.common.persistence.log.AbstractLog;

/**
 * 日志ENTITY工厂
 */
public interface LogEntityFactory {

    /**
     * 创建日志ENTITY
     *
     * @param clazz
     * @param <T>
     * @return
     */
    <T extends AbstractLog> T create(Class<T> clazz);
}
