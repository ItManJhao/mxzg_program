package com.ayjs.mxzg.common.persistence.persister;

import com.ayjs.mxzg.common.persistence.AbstractEntity;

import java.util.Collection;
import java.util.List;
import java.util.Map;

/**
 * 存储接口
 */
public interface Persister<K, T extends AbstractEntity> {

    T get(K id);

    List<T> get(Collection<K> ids);

    List<T> list(Map<String, Object> options);

    List<T> listAll();

    void add(T entity);

    void add(Collection<T> entities);

    void remove(T entity);

    void remove(Collection<T> entities);

    void removeAll();

    void update(T entity);

    void update(Collection<T> entities);
}
