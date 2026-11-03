package com.ayjs.mxzg.largecross.infrastructure.persistence;


import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.repository.ICacheAllRepository;
import com.ayjs.mxzg.common.persistence.repository.IRepository;
import com.ayjs.mxzg.common.redis.RedisRepository;

import java.util.List;
import java.util.Map;
import java.util.Objects;

/**
 * 插入和修改的时候同时更新到redis中,查询从数据库中查询
 */
public class AbstractJDBCRedisRepository<K, T extends AbstractEntity> implements IRepository<T>, ICacheAllRepository {

    private final IRepository<T> jdbcRepository;
    private final RedisRepository<K, T> redisRepository;

    public AbstractJDBCRedisRepository(IRepository<T> jdbcRepository, RedisRepository<K, T> redisRepository) {
        this.jdbcRepository = Objects.requireNonNull(jdbcRepository);
        this.redisRepository = Objects.requireNonNull(redisRepository);
    }

    protected IRepository<T> jdbcRepository() {
        return jdbcRepository;
    }

    protected RedisRepository<K, T> redisRepository() {
        return redisRepository;
    }

    @Override
    public void loadAllDataToCache() {
        // 启动时没有删除redis中的数据，所以这里也不全量加载更新redis数据 -- tangyangbo 20200612
        // 加载数据到redis
//        List<T> entities = jdbcRepository.listAll();
//        entities.forEach(redisRepository::addOrUpdate);
    }

    @Override
    public void add(T entity) {
        jdbcRepository.add(entity);
        redisRepository.addOrUpdate(entity);
    }

    @Override
    public void add(List<T> entities) {
        jdbcRepository.add(entities);
        entities.forEach(redisRepository::addOrUpdate);
    }

    @Override
    public void update(T entity) {
        jdbcRepository.update(entity);
        redisRepository.addOrUpdate(entity);
    }

    @Override
    public void update(List<T> entities) {
        jdbcRepository.update(entities);
        redisRepository.addOrUpdate(entities);
    }

    @Override
    public void remove(T entity) {
        jdbcRepository.remove(entity);
        redisRepository.remove(entity);
    }

    @Override
    public void remove(List<T> entities) {
        jdbcRepository.remove(entities);
        entities.forEach(redisRepository::remove);
    }

    @Override
    public T get(Object id) {
        return jdbcRepository.get(id);
    }

    @Override
    public List<T> listAll() {
        return jdbcRepository.listAll();
    }

    @Override
    public List<T> list(Map<String, Object> options) {
        return jdbcRepository.list(options);
    }

    @Override
    public T get(String field, Object value) {
        return jdbcRepository.get(field, value);
    }

    @Override
    public List<T> list(String field, Object value) {
        return jdbcRepository.list(field, value);
    }

    @Override
    public void truncateAll() {
        throw new UnsupportedOperationException();
    }
}
