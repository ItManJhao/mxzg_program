package com.ayjs.mxzg.common.redis;

import com.ayjs.mxzg.common.persistence.annotation.Cache;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Index;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.common.persistence.meta.ColumnMeta;
import com.ayjs.mxzg.common.persistence.meta.IndexMeta;
import com.ayjs.mxzg.common.persistence.meta.MetaException;
import com.ayjs.mxzg.common.util.TypeUtil;
import com.google.common.base.Preconditions;
import com.google.common.collect.ImmutableList;
import com.google.common.collect.ImmutableMap;
import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.extern.slf4j.Slf4j;

import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.function.Function;
import java.util.stream.Collectors;

/**
 * redis 数据元素
 */
@Slf4j
@Getter
@AllArgsConstructor(access = AccessLevel.PRIVATE)
public class RedisTableMeta<T> {

    /**
     * 表名
     */
    private final String name;
    /**
     * 实体类型
     */
    private final Class<T> entityType;
    /**
     * 主键
     */
    private final ColumnMeta pk;
    /**
     * 唯一索引 如果存在, 应当只能存在一个
     */
    private final IndexMeta uk;
    /**
     * 列
     */
    private final List<ColumnMeta> columns;
    /**
     * 列名到类的字段名的映射
     */
    private final Map<String, ColumnMeta> column2field;
    /**
     * 索引
     */
    private final Map<String, IndexMeta> indexes;
    /**
     * 索引缓存
     */
    private final List<RedisCacheMeta> indexesCache;

    public ColumnMeta getColumnMeta(String columnName) {
        return column2field.get(columnName);
    }

    public static <T> RedisTableMeta<T> build(Class<T> clazz) {
        Table table = clazz.getAnnotation(Table.class);
        Preconditions.checkNotNull(table, "%s has no @Table annotation", clazz.getName());

        String name = table.name().trim();
        Preconditions.checkArgument(!"".equals(name), "%s @Table name() can not be empty", clazz.getName());

        List<Field> fields = TypeUtil.resolveAnnotationField(Column.class, clazz);

        List<ColumnMeta> columns = new ArrayList<>();
        Map<String, ColumnMeta> column2field = new HashMap<>();
        ColumnMeta pk = null;
        try {
            for (Field field : fields) {
                field.setAccessible(true);
                ColumnMeta colMeta = ColumnMeta.parse(field);
                if (colMeta == null) {
                    continue;
                }
                columns.add(colMeta);
                column2field.put(colMeta.getName(), colMeta);
                if (colMeta.isPk()) {
                    if (pk != null) {
                        throw new MetaException("duplicate definition of primary key: " + clazz.getName());
                    }
                    pk = colMeta;
                }
            }
        } catch (Exception e) {
            log.error("表{}结构检查失败", name);
            throw e;
        }

        IndexMeta uk = null;
        for (Index index : table.indexes()) {
            IndexMeta indexMeta = IndexMeta.parse(index);
            if (index.type() == Index.IndexType.UNIQUE) {
                if (uk != null) {
                    throw new MetaException("duplicate definition of uk: " + clazz.getName());
                }
                uk = indexMeta;
            }
        }

        Map<String, IndexMeta> indexes = Arrays.stream(table.indexes())
                .map(IndexMeta::parse)
                .collect(Collectors.toMap(IndexMeta::getName, Function.identity()));


        List<RedisCacheMeta> indexesCache = new ArrayList<>();
        for (Cache cache : table.cache()) {
            if (cache.columns().length == 0) {
                continue;
            }
            List<ColumnMeta> colMetas = new ArrayList<>();
            for (String colName : cache.columns()) {
                ColumnMeta colMeta = column2field.get(colName);
                if (colMeta == null) {
                    throw new MetaException("cached field name not exist: " + clazz.getName());
                }
                if (!colMeta.isReadOnly()) {
                    throw new MetaException("cached field should be read only:" + clazz.getName() + "." + colMeta.getField().getName());
                }
                colMetas.add(colMeta);
            }
            RedisCacheMeta cacheMeta = new RedisCacheMeta(colMetas);
            indexesCache.add(cacheMeta);
        }

        return new RedisTableMeta<>(name, clazz, pk, uk,
                ImmutableList.copyOf(columns),
                ImmutableMap.copyOf(column2field),
                ImmutableMap.copyOf(indexes),
                ImmutableList.copyOf(indexesCache));
    }
}
