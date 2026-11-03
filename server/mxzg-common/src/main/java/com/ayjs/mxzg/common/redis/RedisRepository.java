package com.ayjs.mxzg.common.redis;

import java.util.Collection;
import java.util.List;
import java.util.Map;

/**
 * redis 仓储接口
 */
public interface RedisRepository<K, T> {

    T get(K id);

    List<T> get(Collection<K> ids);

    List<T> list(Map<String, Object> options);

    List<T> listAll();

//    void add(T entity);

    /**
     * 不存在新增，存在就更新
     *
     * @param entity
     */
    void addOrUpdate(T entity);

    void addOrUpdate(Collection<T> entities);

    void remove(T entity);

    void removeAll();

//    void update(T entity);
//
//    void update(Collection<T> entities);
}
