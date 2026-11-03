package com.ayjs.mxzg.common.persistence.repository;

import com.ayjs.mxzg.common.persistence.AbstractEntity;

import java.util.List;
import java.util.Map;

/**
 * 存储接口
 */
public interface IRepository<T extends AbstractEntity> {
    /**
     * 增加一个实体
     *
     * @param entity 实体对象
     */
    void add(T entity);

    /**
     * 增加多个实体
     *
     * @param entities 实体对象
     */
    void add(List<T> entities);

    /**
     * 移除一个实体
     *
     * @param entity 实体对象
     */
    void remove(T entity);

    /**
     * 移除多个实体
     *
     * @param entities 实体对象
     */
    void remove(List<T> entities);

    /**
     * 获取一个实体
     *
     * @param id 实体唯一id
     * @return 实体对象
     */
    T get(Object id);

    /**
     * 获取所有对象
     *
     * @return 对象列表
     */
    List<T> listAll();

    /**
     * 筛选符合条件的实体
     *
     * @param options 查询条件
     * @return 实体对象列表
     */
    List<T> list(Map<String, Object> options);

    /**
     * 筛选符合条件的唯一数据
     *
     * @param field 列
     * @param value 列的值
     * @return 数据对象
     */
    T get(String field, Object value);

    /**
     * 筛选符合条件的数据列表
     *
     * @param field 列
     * @param value 列的值
     * @return 数据列表
     */
    List<T> list(String field, Object value);

    /**
     * 保存一个已经存在的实体对象的修改
     *
     * @param entity 实体对象
     */
    void update(T entity);

    /**
     * 保存多个已经存在的实体对象
     *
     * @param entities 实体对象
     */
    void update(List<T> entities);

    /**
     * 一次性截断表结构
     */
    void truncateAll();

}
