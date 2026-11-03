package com.ayjs.mxzg.common.redis;

import com.ayjs.mxzg.common.base.Initialization;
import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.util.TypeUtil;
import com.ayjs.mxzg.common.util.tuple.Tuple2;
import com.ayjs.mxzg.common.util.tuple.Tuples;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.connection.RedisConnectionFactory;

import java.util.Collection;
import java.util.List;
import java.util.Map;
import java.util.Objects;

/**
 * redis 抽象仓储
 */
public abstract class AbstractRedisRepository<K, T extends AbstractEntity> implements RedisRepository<K, T>, Initialization {

    @Autowired
    private RedisConnectionFactory redisConnectionFactory;

    private RedisPersister<K, T> persister;

    @Override
    public void initialize() {
        Tuple2<Class<K>, Class<T>> tuple = resolveEntityType(this);
        this.persister = new RedisPersister<>(tuple._1, tuple._2, redisConnectionFactory);
    }

    @SuppressWarnings("unchecked")
    private Tuple2<Class<K>, Class<T>> resolveEntityType(RedisRepository<K, T> bean) {
        Class<?>[] arguments = TypeUtil.resolveClassArguments(bean.getClass(), RedisRepository.class);
        return Tuples.of((Class<K>) arguments[0], (Class<T>) arguments[1]);
    }

    @Override
    public T get(K id) {
        return persister.get(id);
    }

    @Override
    public List<T> get(Collection<K> ids) {
        return persister.get(ids);
    }

    @Override
    public List<T> list(Map<String, Object> options) {
        return persister.list(options);
    }

    @Override
    public List<T> listAll() {
        return persister.listAll();
    }

    //    @Override
    private void add(T entity) {
        persister.add(entity);
    }

    @Override
    public void addOrUpdate(T entity) {
        T t = persister.get(persister.getPKValue(entity));
        if (Objects.isNull(t)) {
            add(entity);
        } else {
            update(entity);
        }
    }

    @Override
    public void addOrUpdate(Collection<T> entities) {
        entities.forEach(this::addOrUpdate);
    }

    @Override
    public void remove(T entity) {
        persister.remove(entity);
    }

    @Override
    public void removeAll() {
        persister.removeAll();
    }

    //    @Override
    private void update(T entity) {
        persister.update(entity);
    }

    //    @Override
    private void update(Collection<T> entities) {
        persister.update(entities);
    }

    public List<T> fuzzySearch(String option) {
        return persister.fuzzySearch(option);
    }
}
