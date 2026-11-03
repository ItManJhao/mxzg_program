package com.ayjs.mxzg.common.persistence.sharding;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.SqlBuilder;
import com.ayjs.mxzg.common.persistence.TableRegistry;
import com.ayjs.mxzg.common.persistence.meta.MetaData;
import com.ayjs.mxzg.common.util.tuple.Tuple2;
import com.ayjs.mxzg.common.util.tuple.Tuples;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;

import java.time.LocalDateTime;
import java.util.Collection;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * 分表sql组装
 */
@Component
@Slf4j
public class ShardingSqlAssembly<K, T extends AbstractEntity> {
    @Autowired
    private ShardingStrategyRegistry strategyRegistry;
    @Autowired
    private TableRegistry tableRegistry;

    /**
     * 路由到对应的表
     *
     * @param shardingId
     * @param metaData
     * @return
     */
    public String routingTable(Object shardingId, MetaData metaData) {
        ShardingStrategy strategy = strategyRegistry.getOrThrow(metaData.getShardingMeta().getStrategy());
        return strategy.routingTable(shardingId, metaData, LocalDateTime.now());
    }

    public String nextDateTableName(MetaData metaData, LocalDateTime localDateTime) {
        ShardingStrategy strategy = strategyRegistry.getOrThrow(metaData.getShardingMeta().getStrategy());
        return strategy.routingTable(null, metaData, localDateTime);
    }

    /**
     * 路由到对应的表
     *
     * @param metaData
     * @param entity
     * @return
     */
    public String routingTable(MetaData metaData, T entity) {
        Object shardingId = metaData.getShardingValue(entity);
        return routingTable(shardingId, metaData);
    }

    /**
     * 生成根据id查询sql语句
     *
     * @param metaData
     * @param id
     * @return
     */
    public String generateGetSql(MetaData metaData, K id) {
        String tableName = routingTable(id, metaData);
        return SqlBuilder.select(tableName, metaData.getTableMeta().getPk().getName(), id);
    }

    /**
     * 生成根据条件查询sql语句
     *
     * @param metaData
     * @param options
     * @return
     */
    public String generateListSql(MetaData metaData, Map<String, Object> options) {
        Collection<String> tableNames = tableRegistry.get(metaData.getEntityType());
        List<String> sqls = tableNames.stream()
                .map(tableName -> SqlBuilder.list(tableName, metaData.getTableMeta(), options))
                .collect(Collectors.toList());
        return StringUtils.collectionToDelimitedString(sqls, " UNION ALL ");
    }

    /**
     * 生成查询所有sql语句
     *
     * @param metaData
     * @return
     */
    public String generateListAllSql(MetaData metaData) {
        Collection<String> tableNames = tableRegistry.get(metaData.getEntityType());
        List<String> sqls = tableNames.stream()
                .map(SqlBuilder::selectAll)
                .collect(Collectors.toList());
        return StringUtils.collectionToDelimitedString(sqls, " UNION ALL ");
    }

    /**
     * 生成更新sql语句
     *
     * @param metaData
     * @param entity
     * @return
     */
    public String generateUpdateSql(MetaData metaData, T entity) {
        String tableName = routingTable(metaData, entity);
        return generateUpdateSql(tableName, metaData);
    }

    /**
     * 生成更新sql语句 预编译
     *
     * @param tableName
     * @param metaData
     * @return
     */
    public String generateUpdateSql(String tableName, MetaData metaData) {
        return SqlBuilder.psUpdate(tableName, metaData.getTableMeta());
    }

    /**
     * 生成根据主键删除sql语句
     *
     * @param metaData
     * @param id
     * @return
     */
    public String generateRemoveSql(MetaData metaData, K id) {
        String tableName = routingTable(id, metaData);
        return SqlBuilder.delete(tableName, metaData.getTableMeta().getPk().getName(), id);
    }

    /**
     * 生成根据主键删除sql语句 预编译
     *
     * @param tableName
     * @param metaData
     * @return
     */
    public String generateRemoveSql(String tableName, MetaData metaData) {
        return SqlBuilder.psDelete(tableName, metaData.getTableMeta().getPk().getName());
    }

    /**
     * 生成删除所有数据sql语句
     *
     * @param entityType
     * @return
     */
    public List<String> generateRemoveAllSql(Class<T> entityType) {
        Collection<String> tableNames = tableRegistry.get(entityType);
        return tableNames.stream().map(SqlBuilder::deleteAll).collect(Collectors.toList());
    }

    /**
     * 生成插入数据sql语句 预编译
     *
     * @param metaData
     * @param entity
     * @return
     */
    public Tuple2<String, String> generateAddSql(MetaData metaData, T entity) {
        String tableName = routingTable(metaData, entity);
        return Tuples.of(tableName, SqlBuilder.psInsert(tableName, metaData.getTableMeta()));
    }

    /**
     * 生成插入数据sql语句 预编译
     *
     * @param tableName
     * @param metaData
     * @return
     */
    public String generateAddSql(String tableName, MetaData metaData) {
        return SqlBuilder.psInsert(tableName, metaData.getTableMeta());
    }
}
