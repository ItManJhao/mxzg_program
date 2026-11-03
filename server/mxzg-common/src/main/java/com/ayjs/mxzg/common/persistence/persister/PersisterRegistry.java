package com.ayjs.mxzg.common.persistence.persister;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.google.common.base.Preconditions;
import org.springframework.stereotype.Component;

import java.util.HashMap;
import java.util.Map;

/**
 * 数据操作注册
 */
@Component
public class PersisterRegistry<K, T extends AbstractEntity> {

    private final Map<Class<T>, Persister<K, T>> persisterMap = new HashMap<>();

    public void register(Class<T> entityType, Persister<K, T> persister) {
        persisterMap.put(entityType, persister);
    }

    public Persister<K, T> getPersister(Class<T> entityType) {
        Persister<K, T> persister = persisterMap.get(entityType);
        Preconditions.checkNotNull(persister, "{%s}的持久器未找到", entityType);
        return persister;
    }
}
