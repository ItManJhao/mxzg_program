package com.ayjs.mxzg.common.persistence;

/**
 * 实体
 */
public interface Entity<K> {
    /**
     * 获取主键
     *
     * @return
     */
    K getId();

    /**
     * 设置主键
     *
     * @param id
     */
    void setId(K id);
}
