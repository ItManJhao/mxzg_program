package com.ayjs.mxzg.common.redis;

/**
 * 有序实体
 */
public interface SortedEntity<K> {

    /**
     * 获取主键
     *
     * @return
     */
    K getId();

    /**
     * 获取分数
     *
     * @return
     */
    double getScore();
}
