package com.ayjs.mxzg.common.persistence.repository;


import com.ayjs.mxzg.common.cache.ICache;
import com.ayjs.mxzg.common.cache.SimpleCache;
import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.CRepository;
import com.ayjs.mxzg.common.persistence.meta.CacheMeta;
import com.ayjs.mxzg.common.persistence.meta.ColumnMeta;
import com.ayjs.mxzg.common.util.lock.ReferenceCountedLockManager;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 缓存仓储
 * <p>
 * 由于内置缓存，使用时确保对构建缓存的过程保证线程安全
 */
public class CachedJDBCRepository<T extends AbstractEntity> extends JDBCRepository<T> {

    private static final Log log = LogFactory.getLog(CachedJDBCRepository.class);

    protected final ICache<Object, T> cache;

    protected final Map<CacheMeta, ICache<String, List<Object>>> indexCache;

    private final ReferenceCountedLockManager<String> lockManager = new ReferenceCountedLockManager<>();

    protected CachedJDBCRepository() {
        CRepository repository = getAnnotation();
        this.cache = new SimpleCache<>(repository.timeToIdle(),
                repository.timeToLive());
        this.indexCache = new HashMap<>();
        this.meta.getCache().forEach(n ->
                indexCache.put(n, new SimpleCache<>(repository.timeToIdle(), repository.timeToLive())));
        if (repository.async() && meta.getPk().isAuto()) {
            log.error("can not write entity without pk assigned in async mode");
            System.exit(-1);
        }
    }

    private String genKeyOfCache(CacheMeta cacheMeta, T entity) {
        StringBuilder sb = new StringBuilder();
        sb.append(meta.getName()).append("_");
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
        sb.append(meta.getName()).append("_");
        for (int i = 0; i < cacheMeta.getColumns().size(); i++) {
            ColumnMeta columnMeta = cacheMeta.getColumns().get(i);
            sb.append(options.get(columnMeta.getField().getName()));
            if (i < cacheMeta.getColumns().size() - 1)
                sb.append("_");
        }
        return sb.toString();
    }

    private void addCache(T entity) {
        Object pk = meta.getPk().getFieldValue(entity);
        T old = cache.putIfAbsent(pk, entity);
        if (old != null)
            entity = old;
        for (CacheMeta n : meta.getCache()) {
            ICache<String, List<Object>> cache = indexCache.get(n);
            String key = genKeyOfCache(n, entity);
            lockManager.lock(key);
            try {
                List<Object> list = cache.get(key);
                if (list != null) {
                    list.add(pk);
                }
            } finally {
                lockManager.unlock(key);
            }
        }
    }

    private void removeCache(T entity) {
        Object pk = meta.getPk().getFieldValue(entity);
        cache.remove(pk);
        meta.getCache().forEach(n -> {
            ICache<String, List<Object>> cache = indexCache.get(n);
            String key = genKeyOfCache(n, entity);
            lockManager.lock(key);
            try {
                List<Object> list = cache.get(key);
                if (list != null) {
                    list.remove(pk);
                }
            } finally {
                lockManager.unlock(key);
            }
        });
    }

    @Override
    public void add(T entity) {
        super.add(entity);
        addCache(entity);
    }

    @Override
    public void add(List<T> entities) {
        if (meta.getPk().isAuto())
            throw new RuntimeException("can not add list of entities to CachedJDBCRepository, because primary key not found");
        super.add(entities);
        for (T entity : entities)
            addCache(entity);
    }

    @Override
    public void remove(T entity) {
        super.remove(entity);
        removeCache(entity);
    }

    @Override
    public void remove(List<T> entities) {
        super.remove(entities);
        for (T entity : entities)
            removeCache(entity);
    }

    @Override
    public void truncateAll() {
        super.truncateAll();
        this.cache.clear();
        for (CacheMeta n : meta.getCache()) {
            indexCache.get(n).clear();
        }
    }

    @Override
    public T get(Object id) {
        T entity = cache.get(id);
        if (entity != null)
            return entity;
        entity = super.get(id);
        T old = cache.putIfAbsent(id, entity);
        if (old != null)
            return old;
        return entity;
    }

    @Override
    public List<T> listAll() {
        if (log.isWarnEnabled())
			log.warn("All [" + this.meta.getName()
					+ "] data will be queried from database instead of cache, Do not call this method until you fully understand the risks.");
        List<T> list = super.list(null);
        List<T> result = new ArrayList<>();
        for (T entity : list) {
            Object pk = meta.getPk().getFieldValue(entity);
            T old = cache.putIfAbsent(pk, entity);
            result.add(old == null ? entity : old);
        }
        return result;
    }

    @Override
    public List<T> list(Map<String, Object> options) {
        if (options == null || options.size() == 0)
            return listAll();
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
            return super.list(options);
        }
        ICache<String, List<Object>> cache = indexCache.get(used);
        String key = genKeyOfCache(used, options);
        lockManager.lock(key);
        try {
            List<Object> list = cache.get(key);
            if (list != null) {
                List<Object> copy = new ArrayList<>(list);
                List<T> result = new ArrayList<>();
                for (Object id : copy) {
                    T entity = get(id);
                    if (entity != null)
                        result.add(entity);
                }
                return result;
            } else {
                list = new ArrayList<>();
                List<T> query = super.list(options);
                List<T> result = new ArrayList<>();
                for (T entity : query) {
                    Object pk = meta.getPk().getFieldValue(entity);
                    T old = this.cache.putIfAbsent(pk, entity);
                    if (old != null)
                        result.add(old);
                    else
                        result.add(entity);
                    list.add(pk);
                }
                cache.putIfAbsent(key, list);
                return result;
            }
        } finally {
            lockManager.unlock(key);
        }
    }

    @Override
    public T get(String field, Object value) {
        List<T> list = list(field, value);
        return (list == null || list.size() == 0) ? null : list.get(0);
    }

    @Override
    public List<T> list(String field, Object value) {
        Map<String, Object> options = new HashMap<>();
        options.put(field, value);
        return list(options);
    }

    @Override
    public void update(T entity) {
        super.update(entity);
    }

    @Override
    public void update(List<T> entities) {
        super.update(entities);
    }

}
