package com.ayjs.mxzg.common.persistence;

import com.ayjs.mxzg.common.persistence.meta.MetaData;
import com.ayjs.mxzg.common.persistence.repository.DataBaseAccessor;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Component;

import java.util.Collection;
import java.util.concurrent.ConcurrentHashMap;
import java.util.function.Consumer;

/**
 * 表
 */
@Component
public class TableRegistry {

    private final ConcurrentHashMap<Class<?>, ConcurrentHashMap<String, Boolean>> exitingTables = new ConcurrentHashMap<>();

    private ConcurrentHashMap<String, Boolean> getTableMap(Class<?> entityType) {
        return exitingTables.computeIfAbsent(entityType, key -> new ConcurrentHashMap<>());
    }

    public void addTable(Class<?> entityType, String tableName) {
        getTableMap(entityType).put(tableName, Boolean.TRUE);
    }

    private void addTableIfAbsent(Class<?> entityType, String tableName, Consumer<String> consumer) {
        getTableMap(entityType).computeIfAbsent(tableName, key -> {
            consumer.accept(key);
            return Boolean.TRUE;
        });
    }

    public Collection<String> get(Class<?> entityType) {
        return getTableMap(entityType).keySet();
    }

    public void checkOrCreate(String tableName, DataBaseAccessor db, MetaData metaData) {
        addTableIfAbsent(metaData.getEntityType(), tableName, name -> {
            String createTableSql = StringUtils.EMPTY;
            try {
                createTableSql = SqlBuilder.createTable(name, metaData.getTableMeta());
                db.update(createTableSql);
            } catch (Exception e) {
                throw new RuntimeException(String.format("创建表 [%s]sql:%s 失败", metaData.getEntityType().getSimpleName(), createTableSql), e);
            }
        });
    }
}
