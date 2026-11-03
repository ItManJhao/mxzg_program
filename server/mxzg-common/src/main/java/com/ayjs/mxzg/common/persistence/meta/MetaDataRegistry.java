package com.ayjs.mxzg.common.persistence.meta;

import com.ayjs.mxzg.common.util.Asserts;
import com.google.common.base.Preconditions;
import lombok.Getter;
import org.springframework.stereotype.Component;

import java.util.HashMap;
import java.util.Map;

/**
 * 数据存储实体注册器
 */
@Component
public class MetaDataRegistry {
    @Getter
    private final Map<Class<?>, MetaData> entityMetas = new HashMap<>();

    public void register(Class<?> entityType, MetaData metaData) {
        MetaData old = entityMetas.putIfAbsent(entityType, metaData);
        Asserts.isNull(old, String.format("MetaData register duplicated, type: %s", entityType.getName()));
    }

    public MetaData getMetaData(Class<?> entityType) {
        MetaData metaData = entityMetas.get(entityType);
        Preconditions.checkNotNull(metaData, "实体类型%s的MetaData对象未找到", entityType.getName());
        return metaData;
    }
}
