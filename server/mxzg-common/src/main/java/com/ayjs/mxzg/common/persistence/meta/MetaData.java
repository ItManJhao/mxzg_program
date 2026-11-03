package com.ayjs.mxzg.common.persistence.meta;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Sharding;
import com.ayjs.mxzg.common.persistence.annotation.ShardingId;
import com.ayjs.mxzg.common.util.TypeUtil;

/**
 * 描述整个数据存储实体
 */
public class MetaData {
    /**
     * 实体类型
     */
    private final Class<?> entityType;
    /**
     * 表元
     */
    private final TableMeta tableMeta;
    /**
     * 分片id
     */
    private final ColumnMeta shardingId;
    /**
     * 分片信息
     */
    private final ShardingMeta shardingMeta;

    private MetaData(Class<?> entityType, TableMeta tableMeta, ColumnMeta shardingId, ShardingMeta shardingMeta) {
        this.entityType = entityType;
        this.tableMeta = tableMeta;
        this.shardingId = shardingId;
        this.shardingMeta = shardingMeta;
    }

    public static MetaData build(Class<?> entityType) {
        TableMeta tableMeta = parseTableMeta(entityType);
        ColumnMeta shardingId = tableMeta.getColumns().stream()
                .filter(columnMeta -> columnMeta.getField().getAnnotation(ShardingId.class) != null)
                .findFirst()
                .orElse(null);
        if (shardingId != null && !shardingId.isReadOnly()) {
            throw new MetaException(String.format("shardingId field should be read only:%s.%s", entityType.getName(), shardingId.getField().getName()));
        }
        Sharding sharding = TypeUtil.resolveAnnotation(Sharding.class, entityType);
        ShardingMeta shardingMeta;
        if (sharding != null) {
            if (sharding.strategy() != Sharding.Strategy.SINGLE && shardingId == null) {
                throw new MetaException(String.format("@ShardingId not found in class{%s} when sharding strategy is not single", entityType.getName()));
            }
            shardingMeta = ShardingMeta.of(sharding);
        } else {
            shardingMeta = new ShardingMeta(Sharding.Strategy.SINGLE, Sharding.Period.MONTHLY, -1);
        }
        return new MetaData(entityType, tableMeta, shardingId, shardingMeta);
    }

    @SuppressWarnings("unchecked")
    private static TableMeta parseTableMeta(Class<?> entityType) {
        return TableMeta.parse((Class<AbstractEntity>) entityType);
    }

    /**
     * 获取分片id的值，如果分片id不存在则获取主键id
     *
     * @param entity
     * @return
     */
    public <T> Object getShardingValue(T entity) {
        return shardingId != null ? shardingId.getFieldValue((AbstractEntity) entity) : tableMeta.getPk().getFieldValue((AbstractEntity) entity);
    }

    public Class<?> getEntityType() {
        return entityType;
    }

    public ColumnMeta getShardingId() {
        return shardingId;
    }

    public ShardingMeta getShardingMeta() {
        return shardingMeta;
    }

    public TableMeta getTableMeta() {
        return tableMeta;
    }
}
