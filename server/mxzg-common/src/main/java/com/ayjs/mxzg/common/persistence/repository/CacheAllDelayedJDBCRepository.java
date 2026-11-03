package com.ayjs.mxzg.common.persistence.repository;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.CRepository;
import com.ayjs.mxzg.common.persistence.hook.HookHandler;
import com.ayjs.mxzg.common.persistence.hook.HookOpportunity;
import com.ayjs.mxzg.common.persistence.meta.CacheMeta;
import com.ayjs.mxzg.common.persistence.meta.ColumnMeta;
import com.google.common.collect.ImmutableList;
import com.google.common.collect.ImmutableMap;
import com.google.common.collect.Iterables;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentMap;
import java.util.stream.Collectors;

/**
 * Notice:
 * <p>
 * 1. 所有继承了{@code DelayedJDBCRepository}的仓储在{@code @Index} 构建时,
 * 如果是唯一索引, 那么被索引的内容不应该被修改, 否则可能会出现唯一索引冲突的情况。
 * 这是因为 {@code add}, {@code remove} 是即时更新到数据库中, 而 {@code save} 是延迟更新到数据库中。
 */
@Slf4j
@CRepository(source = "data", timeToLive = 1)
public class CacheAllDelayedJDBCRepository<T extends AbstractEntity> extends DelayedJDBCRepository<T> implements ICacheAllRepository {

    /**
     * 全表数据缓存
     */
    private final ConcurrentMap<Object, T> allDataCache = new ConcurrentHashMap<>();
    /**
     * 索引缓存
     */
    private final ConcurrentMap<CacheMeta, ConcurrentMap<String, Set<Object>>> indexCache = new ConcurrentHashMap<>();

    @Autowired
    private HookHandler<T> hookHandler;

    private boolean allMatch(T entity, Map<String, Object> options) {
        return options.entrySet().stream().allMatch(entry -> match(entity, entry.getKey(), entry.getValue()));
    }

    private boolean match(T instance, String filed, Object value) {
        ColumnMeta columnMeta = meta.getColumnMetaByFieldName(filed);
        return columnMeta != null && Objects.equals(columnMeta.getFieldValue(instance), value);
    }

    private Object getPkValue(AbstractEntity entity) {
        return meta.getPk().getFieldValue(entity);
    }

    private void addToCache(T entity) {
        Object pk = getPkValue(entity);
        if (allDataCache.putIfAbsent(pk, entity) == null) {
            meta.getCache().forEach(cacheMeta -> getIndexPks(cacheMeta, entity).add(pk));
        }
    }

    private Set<Object> getIndexPks(CacheMeta cacheMeta, T entity) {
        return indexCache.computeIfAbsent(cacheMeta, key -> new ConcurrentHashMap<>())
                .computeIfAbsent(genKeyOfCache(cacheMeta, entity), key -> ConcurrentHashMap.newKeySet());
    }

    private void removeFromCache(T entity) {
        Object pk = getPkValue(entity);
        T previous = allDataCache.remove(pk);
        if (previous != null) {
            meta.getCache().forEach(cacheMeta -> {
                ConcurrentMap<String, Set<Object>> cache = indexCache.get(cacheMeta);
                if (cache != null) {
                    String key = genKeyOfCache(cacheMeta, entity);
                    Set<Object> pks = cache.get(key);
                    if (pks != null) {
                        pks.remove(pk);
                    }
                }
            });
        }
    }

    private String genKeyOfCache(CacheMeta cacheMeta, T entity) {
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < cacheMeta.getColumns().size(); i++) {
            ColumnMeta columnMeta = cacheMeta.getColumns().get(i);
            sb.append(columnMeta.getFieldValue(entity));
            if (i < cacheMeta.getColumns().size() - 1)
                sb.append("_");
        }
        return sb.toString();
    }

    private String genKeyOfCache(CacheMeta cacheMeta, Map<String, Object> options) {
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < cacheMeta.getColumns().size(); i++) {
            ColumnMeta columnMeta = cacheMeta.getColumns().get(i);
            sb.append(options.get(columnMeta.getField().getName()));
            if (i < cacheMeta.getColumns().size() - 1)
                sb.append("_");
        }
        return sb.toString();
    }

    @Override
    public void loadAllDataToCache() {
        super.listAll().forEach(this::addToCache);
    }

    @Override
    public void add(T entity) {
        super.add(entity);
        addToCache(entity);
    }

    @Override
    public void add(List<T> entities) {
        super.add(entities);
        entities.forEach(this::addToCache);
    }

    @Override
    public void remove(T entity) {
        super.remove(entity);
        removeFromCache(entity);
    }

    @Override
    public void remove(List<T> entities) {
        super.remove(entities);
        entities.forEach(this::removeFromCache);
    }

    @Override
    public T get(Object id) {
        T entity = allDataCache.get(id);
        if (entity != null) {
            if (hookHandler.hookIt(entity, HookOpportunity.GET_AFTER)) {
                update(entity);
            }
        }
        return entity;
    }

    @Override
    public List<T> listAll() {
        List<T> list = ImmutableList.copyOf(allDataCache.values());
        list.forEach(entity -> {
            if (hookHandler.hookIt(entity, HookOpportunity.GET_AFTER)) {
                update(entity);
            }
        });
        return list;
    }

    @Override
    public List<T> list(Map<String, Object> options) {
        if (options == null || options.isEmpty()) {
            return Collections.emptyList();
        }
        CacheMeta used = null;
        for (CacheMeta cacheMeta : meta.getCache()) {
            if (cacheMeta.match(options)) {
                used = cacheMeta;
                break;
            }
        }
        if (used == null) {
            if (log.isWarnEnabled()) {
                StringBuilder sb = new StringBuilder();
                for (String field : options.keySet()) {
                    sb.append(field).append(" ");
                }
                log.warn(meta.getClazz().getName() + ": no @Cache found on field [" + sb.toString() + "]");
            }
            return allDataCache.values().stream().filter(entity -> allMatch(entity, options)).collect(Collectors.toList());
        }

        ConcurrentMap<String, Set<Object>> cache = indexCache.get(used);
        if (cache == null) {
            return Collections.emptyList();
        }

        String key = genKeyOfCache(used, options);
        Set<Object> pks = cache.get(key);

        if (pks == null) {
            return Collections.emptyList();
        }

        return pks.stream().map(this::get).filter(Objects::nonNull).collect(Collectors.toList());
    }

    @Override
    public T get(String field, Object value) {
        List<T> entities = list(field, value);
        return Iterables.getFirst(entities, null);
    }

    @Override
    public List<T> list(String field, Object value) {
        Map<String, Object> options = ImmutableMap.of(field, value);
        return list(options);
    }
    
    public boolean contains(Object pk) {
    	return allDataCache.containsKey(pk);
    }
}
