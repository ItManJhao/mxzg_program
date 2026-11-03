package com.ayjs.mxzg.common.redis;

import com.ayjs.mxzg.common.convert.ConvertUtils;
import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.meta.ColumnMeta;
import com.ayjs.mxzg.common.persistence.persister.Persister;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.InternerPool;
import com.google.common.collect.ImmutableList;
import com.google.common.reflect.TypeParameter;
import com.google.common.reflect.TypeToken;
import lombok.extern.slf4j.Slf4j;
import org.springframework.dao.DataAccessException;
import org.springframework.data.redis.connection.RedisConnection;
import org.springframework.data.redis.connection.RedisConnectionFactory;
import org.springframework.data.redis.core.Cursor;
import org.springframework.data.redis.core.HashOperations;
import org.springframework.data.redis.core.RedisCallback;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.core.ScanOptions;
import org.springframework.data.redis.serializer.RedisSerializer;
import org.springframework.data.redis.serializer.StringRedisSerializer;
import org.springframework.util.Assert;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Set;

/**
 *
 */
@Slf4j
public class RedisPersister<K, T extends AbstractEntity> implements Persister<K, T> {

    private static final String SPLIT_COLON = ":";

    private final RedisTableMeta<T> tableMeta;

    private final RedisTemplate<String, T> redisTemplate;
    private final RedisTemplate<String, K> ukRedisTemplate;
    private final RedisTemplate<String, Set<K>> idxRedisTemplate;

    private final String dataName;
    private final String ukName;
    private final String idxName;

    private final int slowLog;

    public RedisPersister(Class<K> idType, Class<T> entityType, RedisConnectionFactory connectionFactory) {
        this(idType, entityType, connectionFactory, 50);
    }

    public RedisPersister(Class<K> idType, Class<T> entityType, RedisConnectionFactory connectionFactory, int slowLog) {
        this.tableMeta = RedisTableMeta.build(entityType);
        this.redisTemplate = buildRedisTemplate(idType, entityType, connectionFactory);
        this.ukRedisTemplate = buildUkRedisTemplate(idType, connectionFactory);
        this.idxRedisTemplate = buildIdxRedisTemplate(idType, connectionFactory);
        this.dataName = tableMeta.getName() + SPLIT_COLON + "data";
        this.ukName = tableMeta.getName() + SPLIT_COLON + "uk";
        this.idxName = tableMeta.getName() + SPLIT_COLON + "idx";
        this.slowLog = slowLog;
    }

    private RedisTemplate<String, T> buildRedisTemplate(Class<K> idType, Class<T> entityType, RedisConnectionFactory connectionFactory) {
        RedisTemplate<String, T> template = new RedisTemplate<>();
        template.setConnectionFactory(connectionFactory);
        template.setKeySerializer(new StringRedisSerializer());
        template.setHashKeySerializer(new FastJsonRedisSerializer<>(idType));
        template.setHashValueSerializer(new FastJsonRedisSerializer<>(entityType));
        template.afterPropertiesSet();
        return template;
    }

    private RedisTemplate<String, K> buildUkRedisTemplate(Class<K> idType, RedisConnectionFactory connectionFactory) {
        RedisTemplate<String, K> template = new RedisTemplate<>();
        template.setConnectionFactory(connectionFactory);
        template.setKeySerializer(new StringRedisSerializer());
        template.setHashKeySerializer(new StringRedisSerializer());
        template.setHashValueSerializer(new FastJsonRedisSerializer<>(idType));
        template.afterPropertiesSet();
        return template;
    }

    private RedisTemplate<String, Set<K>> buildIdxRedisTemplate(Class<K> idType, RedisConnectionFactory connectionFactory) {
        RedisTemplate<String, Set<K>> template = new RedisTemplate<>();
        template.setConnectionFactory(connectionFactory);
        template.setKeySerializer(new StringRedisSerializer());
        template.setHashKeySerializer(new StringRedisSerializer());
        template.setHashValueSerializer(new FastJsonRedisSerializer<>(setOf(idType).getType()));
        template.afterPropertiesSet();
        return template;
    }

    private <E> TypeToken<Set<E>> setOf(Class<E> type) {
        return new TypeToken<Set<E>>() {
        }.where(new TypeParameter<E>() {
        }, type);
    }

    private String dataName() {
        return dataName;
    }

    private String ukName() {
        return ukName;
    }

    private String idxName(RedisCacheMeta cacheMeta) {
        return idxName + SPLIT_COLON + cacheMeta.getName();
    }

    private void addUk(T entity) {
        if (tableMeta.getUk() == null) {
            return;
        }
        String key = ukName();
        String uk = buildUk(entity);
        boolean success = ukRedisTemplate.<String, K>opsForHash().putIfAbsent(key, uk, getPKValue(entity));
        if (!success) {
            throw new RuntimeException("duplicate uk(" + uk + ") on " + key);
        }
    }

    private void removeUk(T entity) {
        if (tableMeta.getUk() == null) {
            return;
        }
        String key = ukName();
        String uk = buildUk(entity);
        idxRedisTemplate.<String, K>opsForHash().delete(key, uk);
    }

    private String buildUk(T entity) {
        StringBuilder sb = new StringBuilder();
        Iterator<String> it = tableMeta.getUk().getColumns().iterator();
        while (it.hasNext()) {
            ColumnMeta col = tableMeta.getColumnMeta(it.next());
            sb.append(getFieldValue(col, entity));
            if (it.hasNext()) {
                sb.append(SPLIT_COLON);
            }
        }
        return sb.toString();
    }

    private void addIdxCache(T entity) {
        tableMeta.getIndexesCache().forEach(meta -> addIdxCache(entity, meta));
    }

    private void removeIdxCache(T entity) {
        tableMeta.getIndexesCache().forEach(meta -> removeIdxCache(entity, meta));
    }

    private void addIdxCache(T entity, RedisCacheMeta meta) {
        String key = idxName(meta);
        String idx = buildIdx(entity, meta);
        HashOperations<String, String, Set<K>> operations = idxRedisTemplate.opsForHash();
        synchronized (InternerPool.intern(idx)) {
            Set<K> ids = operations.get(key, idx);
            if (ids == null) {
                ids = new HashSet<>();
            }
            ids.add(getPKValue(entity));
            operations.put(key, idx, ids);
        }
    }

    private void removeIdxCache(T entity, RedisCacheMeta meta) {
        String key = idxName(meta);
        String idx = buildIdx(entity, meta);
        HashOperations<String, String, Set<K>> operations = idxRedisTemplate.opsForHash();
        synchronized (InternerPool.intern(idx)) {
            Set<K> ids = operations.get(key, idx);
            if (ids != null) {
                ids.remove(getPKValue(entity));
                if (ids.isEmpty()) {
                    operations.delete(key, idx);
                } else {
                    operations.put(key, idx, ids);
                }
            }
        }
    }

    private String buildIdx(T entity, RedisCacheMeta meta) {
        StringBuilder sb = new StringBuilder();
        Iterator<ColumnMeta> it = meta.getColumns().iterator();
        while (it.hasNext()) {
            ColumnMeta col = it.next();
            sb.append(getFieldValue(col, entity));
            if (it.hasNext()) {
                sb.append(SPLIT_COLON);
            }
        }
        return sb.toString();
    }

    private String buildIdx(RedisCacheMeta meta, Map<String, Object> options) {
        StringBuilder sb = new StringBuilder();
        Iterator<ColumnMeta> it = meta.getColumns().iterator();
        while (it.hasNext()) {
            ColumnMeta col = it.next();
            sb.append(options.get(col.getField().getName()));
            if (it.hasNext()) {
                sb.append(SPLIT_COLON);
            }
        }
        return sb.toString();
    }

    private Object getFieldValue(ColumnMeta columnMeta, T entity) {
        try {
            return columnMeta.getField().get(entity);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    protected K getPKValue(T entity) {
        try {
            return (K) tableMeta.getPk().getField().get(entity);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    private RedisCacheMeta findMatch(Map<String, Object> options) {
        return tableMeta.getIndexesCache().stream().filter(meta -> meta.match(options)).findFirst().orElse(null);
    }

    @Override
    public T get(K id) {
        long t = System.currentTimeMillis();
        try {
            return redisTemplate.<K, T>opsForHash().get(dataName(), id);
        } finally {
            t = System.currentTimeMillis() - t;
            if (t > slowLog) {
                log.warn(String.format("查询数据 [%s] #id:%s 耗时 %s ms!", dataName(), id, t));
            }
        }
    }

    @Override
    public List<T> get(Collection<K> ids) {
        if (ids == null || ids.isEmpty()) {
            return Collections.emptyList();
        }
        long t = System.currentTimeMillis();
        try {
            return redisTemplate.<K, T>opsForHash().multiGet(dataName, ids);
        } finally {
            t = System.currentTimeMillis() - t;
            if (t > slowLog) {
                log.warn(String.format("查询数据 [%s] #ids:%s 耗时 %s ms!", dataName(), ids, t));
            }
        }
    }

    @Override
    public List<T> list(Map<String, Object> options) {
        Assert.notEmpty(options, "查询条件不应该为空");
        RedisCacheMeta meta = findMatch(options);
        Asserts.notNull(meta, () -> {
            StringBuilder sb = new StringBuilder();
            options.forEach((field, v) -> sb.append(field).append(" "));
            return String.format("%s : no @Cache found on field [%s]", tableMeta.getEntityType().getName(), sb.toString());
        });
        String key = idxName(meta);
        String idx = buildIdx(meta, options);

        long t = System.currentTimeMillis();
        try {
            Set<K> ids = idxRedisTemplate.<String, Set<K>>opsForHash().get(key, idx);
            return ids == null ? ImmutableList.of() : redisTemplate.<K, T>opsForHash().multiGet(dataName(), ids);
        } finally {
            t = System.currentTimeMillis() - t;
            if (t > slowLog) {
                log.warn(String.format("条件查询数据 [%s] #options:%s 耗时 %s ms!", dataName(), options, t));
            }
        }
    }

    @Override
    public List<T> listAll() {
        long t = System.currentTimeMillis();
        try {
            return redisTemplate.<K, T>opsForHash().values(dataName());
        } finally {
            t = System.currentTimeMillis() - t;
            if (t > slowLog) {
                log.warn(String.format("查询全表数据 [%s] 耗时 %s ms!", dataName(), t));
            }
        }
    }

    @Override
    public void add(T entity) {
        long t = System.currentTimeMillis();
        try {
            // 唯一索引
            addUk(entity);
            boolean success = redisTemplate.<K, T>opsForHash().putIfAbsent(dataName(), getPKValue(entity), entity);
            if (!success) {
                removeUk(entity);
                throw new RuntimeException("duplicate primary key:" + getPKValue(entity) + " of " + dataName());
            }
            // 索引缓存
            addIdxCache(entity);
        } finally {
            t = System.currentTimeMillis() - t;
            if (t > slowLog) {
                log.warn(String.format("插入数据 [%s] #id:%s 耗时 %s ms!", dataName(), getPKValue(entity), t));
            }
        }
    }

    @Override
    public void add(Collection<T> entities) {
        if (entities == null || entities.isEmpty()) {
            return;
        }
        long t = System.currentTimeMillis();
        try {
            entities.forEach(this::add);
        } finally {
            t = System.currentTimeMillis() - t;
            if (t > slowLog) {
                log.warn(String.format("插入数据 [%s] #size:%s 耗时 %s ms!", dataName(), entities.size(), t));
            }
        }
    }

    @Override
    public void remove(T entity) {
        long t = System.currentTimeMillis();
        try {
            removeIdxCache(entity);
            redisTemplate.<K, T>opsForHash().delete(dataName(), getPKValue(entity));
            removeUk(entity);
        } finally {
            t = System.currentTimeMillis() - t;
            if (t > slowLog) {
                log.warn(String.format("删除数据 [%s] #id:%s 耗时 %s ms!", dataName(), getPKValue(entity), t));
            }
        }
    }

    @Override
    public void remove(Collection<T> entities) {
        long t = System.currentTimeMillis();
        try {
            entities.forEach(this::remove);
        } finally {
            t = System.currentTimeMillis() - t;
            if (t > slowLog) {
                log.warn(String.format("删除数据 [%s] #size:%s 耗时 %s ms!", dataName(), entities.size(), t));
            }
        }
    }

    @Override
    public void removeAll() {
        long t = System.currentTimeMillis();
        try {
            tableMeta.getIndexesCache().forEach(meta -> idxRedisTemplate.delete(idxName(meta)));
            redisTemplate.delete(dataName());
            ukRedisTemplate.delete(ukName());
        } finally {
            t = System.currentTimeMillis() - t;
            if (t > slowLog) {
                log.warn(String.format("删除全表数据 [%s] 耗时 %s ms!", dataName(), t));
            }
        }
    }

    @Override
    public void update(T entity) {
        long t = System.currentTimeMillis();
        try {
            HashOperations<String, K, T> operations = redisTemplate.opsForHash();
            if (operations.hasKey(dataName(), getPKValue(entity))) {
                operations.put(dataName(), getPKValue(entity), entity);
            }
        } finally {
            t = System.currentTimeMillis() - t;
            if (t > slowLog) {
                log.warn(String.format("更新数据 [%s] #id:%s 耗时 %s ms!", dataName(), getPKValue(entity), t));
            }
        }
    }

    @Override
    public void update(Collection<T> entities) {
        long t = System.currentTimeMillis();
        RedisPersister perisher = this;
        try {
            redisTemplate.executePipelined(new RedisCallback<Collection<T>>() {
                @Override
                public Collection<T> doInRedis(RedisConnection connection) throws DataAccessException {
                    RedisSerializer<String> keySerializer = (RedisSerializer<String>) redisTemplate.getKeySerializer();
                    RedisSerializer<T> valueSerializer = (RedisSerializer<T>) redisTemplate.getValueSerializer();
                    for (T entity : entities) {
                        byte[] rawKey = keySerializer.serialize(perisher.dataName());
                        byte[] rawHashKey = keySerializer.serialize(ConvertUtils.toString(perisher.getPKValue(entity)));
                        byte[] rawHashValue = valueSerializer.serialize(entity);
                        if (Objects.isNull(rawKey) || Objects.isNull(rawHashKey) || Objects.isNull(rawHashValue)) {
                            connection.hSet(rawKey, rawHashKey, rawHashValue);
                        } else {
                            log.debug("rawKey:{},rawHashKey:{},rawHashValue:{}", rawKey, rawHashKey, rawHashValue);
                        }
                    }
                    return null;
                }
            });
//            entities.forEach(this::update);
        } finally {
            t = System.currentTimeMillis() - t;
            if (t > slowLog) {
                log.warn(String.format("更新数据 [%s] #size:%s 耗时 %s ms!", dataName(), entities.size(), t));
            }
        }
    }

    public List<T> fuzzySearch(String option) {
        long t = System.currentTimeMillis();
        try {
            ScanOptions scanOptions = ScanOptions.scanOptions().match("*" + option + "*").build();
            Cursor<Map.Entry<K, T>> cursor = redisTemplate.<K, T>opsForHash().scan(dataName(), scanOptions);
            Map<K, T> map = new HashMap<>();
            while (cursor.hasNext()) {
                Map.Entry<K, T> entry = cursor.next();
                map.put(entry.getKey(), entry.getValue());
            }
            return new ArrayList<>(map.values());
        } finally {
            t = System.currentTimeMillis() - t;
            if (t > slowLog) {
                log.warn(String.format("模糊查询数据 [%s] #option:%s 耗时 %s ms!", dataName(), option, t));
            }
        }
    }
}
