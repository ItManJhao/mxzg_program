package com.ayjs.mxzg.common.persistence.persister;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.TableRegistry;
import com.ayjs.mxzg.common.persistence.meta.ColumnMeta;
import com.ayjs.mxzg.common.persistence.meta.MetaData;
import com.ayjs.mxzg.common.persistence.repository.DataBaseAccessor;
import com.ayjs.mxzg.common.persistence.sharding.ShardingSqlAssembly;
import com.ayjs.mxzg.common.util.gson.GsonUtils;
import com.ayjs.mxzg.common.util.tuple.Tuple2;
import com.google.common.collect.Iterables;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Collection;
import java.util.Collections;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * 数据操作
 */
@Slf4j
public class JdbcPersister<K, T extends AbstractEntity> implements Persister<K, T> {
    @Autowired
    private ShardingSqlAssembly<K, T> sqlAssembly;
    @Autowired
    private TableRegistry tableRegistry;

    /**
     * 实体类型
     */
    private final Class<T> entityType;

    private final MetaData metaData;

    private final DataBaseAccessor dataBaseAccessor;
    /**
     * 慢查询阈值(单位：毫秒)
     */
    private final int slowLog;

    public JdbcPersister(Class<T> entityType, DataBaseAccessor dataBaseAccessor, MetaData metaData, int slowLog) {
        this.entityType = entityType;
        this.dataBaseAccessor = dataBaseAccessor;
        this.metaData = metaData;
        this.slowLog = slowLog;
    }

    @Override
    public T get(K id) {
        String sql = StringUtils.EMPTY;
        try {
            sql = sqlAssembly.generateGetSql(metaData, id);
            List<T> list = PersisterSupport.parse(metaData, dataBaseAccessor.query(sql));
            return Iterables.getFirst(list, null);
        } catch (Exception e) {
            throw new RuntimeException(String.format("查询数据 [%s]sql:%s 异常!", entityType.getSimpleName(), sql), e);
        }
    }

    @Override
    public List<T> get(Collection<K> ids) {
        throw new UnsupportedOperationException();
    }

    @Override
    public List<T> list(Map<String, Object> options) {
        String sql = StringUtils.EMPTY;
        try {
            sql = sqlAssembly.generateListSql(metaData, options);
            return PersisterSupport.parse(metaData, dataBaseAccessor.query(sql));
        } catch (Exception e) {
            throw new RuntimeException(String.format("查询数据 [%s]sql:%s 异常!", entityType.getSimpleName(), sql), e);
        }
    }

    @Override
    public List<T> listAll() {
        String sql = StringUtils.EMPTY;
        try {
            sql = sqlAssembly.generateListAllSql(metaData);
            return PersisterSupport.parse(metaData, dataBaseAccessor.query(sql));
        } catch (Exception e) {
            throw new RuntimeException(String.format("查询数据 [%s]sql:%s 异常!", entityType.getSimpleName(), sql), e);
        }
    }

    @Override
    public void add(T entity) {
        Tuple2<String, String> tuple = sqlAssembly.generateAddSql(metaData, entity);
        tableRegistry.checkOrCreate(tuple._1, dataBaseAccessor, metaData);
        String sql = tuple._2;
        if (log.isDebugEnabled()) {
            log.debug(sql);
        }
        long t = System.currentTimeMillis();
        try (Connection connection = dataBaseAccessor.getConnection(); PreparedStatement ps = connection.prepareStatement(sql)) {
            prepareStatementInsert(ps, entity);
            ps.executeUpdate();
        } catch (Exception e) {
            throw new RuntimeException(String.format("插入数据 [%s]sql:%s 异常!", entityType.getSimpleName(), sql), e);
        } finally {
            logIfSlowQuery(sql, System.currentTimeMillis() - t);
        }
    }

    private void prepareStatementInsert(PreparedStatement ps, T entity) throws Exception {
        int index = 1;
        for (int i = 0; i < metaData.getTableMeta().getColumns().size(); i++) {
            ColumnMeta col = metaData.getTableMeta().getColumns().get(i);
            if (!col.isPk() || !col.isAuto()) {
                prepareStatement(ps, index++, col, entity);
            }
        }
    }

    @Override
    public void add(Collection<T> entities) {
        if (entities == null || entities.size() == 0) {
            return;
        }
        Map<String, List<T>> map = groupingByTableName(metaData, entities);
        map.forEach((tableName, adds) -> {
            tableRegistry.checkOrCreate(tableName, dataBaseAccessor, metaData);
            String sql = sqlAssembly.generateAddSql(tableName, metaData);
            batchAdd(sql, adds);
        });
    }

    private void batchAdd(String sql, Collection<T> entities) {
        if (log.isDebugEnabled()) {
            log.debug(sql);
        }
        long t = System.currentTimeMillis();
        Connection connection = null;
        PreparedStatement ps = null;
        try {
            connection = dataBaseAccessor.getConnection();
            connection.setAutoCommit(false);
            ps = connection.prepareStatement(sql);
            for (T entity : entities) {
                prepareStatementInsert(ps, entity);
                ps.addBatch();
            }
            ps.executeBatch();
            connection.commit();
        } catch (Exception e) {
            throw new RuntimeException(String.format("批量插入数据 [%s]sql:%s 异常!", entityType.getSimpleName(), sql), e);
        } finally {
            if (ps != null) {
                try {
                    ps.close();
                } catch (SQLException e) {
                    log.error("close statement failed", e);
                }
            }
            if (connection != null) {
                try {
                    connection.setAutoCommit(true);
                    connection.close();
                } catch (SQLException e) {
                    log.error("close connection failed", e);
                }
            }
            logIfSlowQuery(sql, System.currentTimeMillis() - t);
        }
    }

    @Override
    public void remove(T entity) {
        String sql = StringUtils.EMPTY;
        try {

//            sql = sqlAssembly.generateRemoveSql(metaData, entity.getId());
            sql = sqlAssembly.generateRemoveSql(metaData, (K) metaData.getTableMeta().getPk().getName());
            dataBaseAccessor.update(sql);
        } catch (Exception e) {
            throw new RuntimeException(String.format("删除数据 [%s]sql:%s 异常!", entityType.getSimpleName(), sql), e);
        }
    }

    @Override
    public void remove(Collection<T> entities) {
        if (entities == null || entities.size() == 0) {
            return;
        }
        Map<String, List<T>> map = groupingByTableName(metaData, entities);
        map.forEach((tableName, removes) -> {
            String sql = sqlAssembly.generateRemoveSql(tableName, metaData);
            batchRemove(sql, removes);
        });
    }

    private void batchRemove(String sql, Collection<T> entities) {
        if (log.isDebugEnabled()) {
            log.debug(sql);
        }
        long t = System.currentTimeMillis();
        Connection connection = null;
        PreparedStatement ps = null;
        try {
            connection = dataBaseAccessor.getConnection();
            connection.setAutoCommit(false);
            ps = connection.prepareStatement(sql);
            for (T entity : entities) {
                prepareStatement(ps, 1, metaData.getTableMeta().getPk(), entity);
                ps.addBatch();
            }
            ps.executeBatch();
            connection.commit();
        } catch (Exception e) {
            throw new RuntimeException(String.format("批量插入数据 [%s]sql:%s 异常!", entityType.getSimpleName(), sql), e);
        } finally {
            if (ps != null) {
                try {
                    ps.close();
                } catch (SQLException e) {
                    log.error("close statement failed", e);
                }
            }
            if (connection != null) {
                try {
                    connection.setAutoCommit(true);
                    connection.close();
                } catch (SQLException e) {
                    log.error("close connection failed", e);
                }
            }
            logIfSlowQuery(sql, System.currentTimeMillis() - t);
        }
    }

    @Override
    public void removeAll() {
        List<String> sql = Collections.emptyList();
        try {
            sql = sqlAssembly.generateRemoveAllSql(entityType);
            if (log.isDebugEnabled()) {
                log.debug(sql.toString());
            }
            dataBaseAccessor.batch(sql);
        } catch (Exception e) {
            throw new RuntimeException(String.format("删除全表数据 [%s]sql:%s 异常!", entityType.getSimpleName(), sql), e);
        }
    }

    @Override
    public void update(T entity) {
        long t = System.currentTimeMillis();
        String sql = sqlAssembly.generateUpdateSql(metaData, entity);
        if (log.isDebugEnabled()) {
            log.debug(sql);
        }
        try (Connection connection = dataBaseAccessor.getConnection(); PreparedStatement ps = connection.prepareStatement(sql)) {
            prepareStatementUpdate(ps, entity);
            ps.executeUpdate();
        } catch (Exception e) {
            throw new RuntimeException(String.format("修改数据 [%s]sql:%s 异常!", entityType.getSimpleName(), sql), e);
        } finally {
            logIfSlowQuery(sql, System.currentTimeMillis() - t);
        }
    }

    private void logIfSlowQuery(String sql, long t) {
        if (t > slowLog) {
            if (log.isWarnEnabled()) {
                log.warn("slow sql [" + t + "]" + sql);
            }
        }
    }

    private void prepareStatementUpdate(PreparedStatement ps, T entity) throws Exception {
        int index = 1;
        for (ColumnMeta col : metaData.getTableMeta().getColumns()) {
            if (!col.isReadOnly() && !col.isPk()) {
                prepareStatement(ps, index++, col, entity);
            }
        }
        prepareStatement(ps, index, metaData.getTableMeta().getPk(), entity);
    }

    private void prepareStatement(PreparedStatement ps, int index, ColumnMeta meta, T entity)
            throws IllegalAccessException, IllegalArgumentException, SQLException {
        switch (meta.getType()) {
            case INT:
                ps.setInt(index, meta.getField().getInt(entity));
                break;
            case BIGINT:
                ps.setLong(index, meta.getField().getLong(entity));
                break;
            case SMALLINT:
                ps.setShort(index, meta.getField().getShort(entity));
                break;
            case TINYINT:
                if (meta.getField().getType() == Boolean.class || meta.getField().getType() == boolean.class) {
                    ps.setByte(index, meta.getField().getBoolean(entity) ? (byte) 1 : 0);
                } else {
                    ps.setByte(index, meta.getField().getByte(entity));
                }
                break;
            case DOUBLE:
                ps.setDouble(index, meta.getField().getDouble(entity));
                break;
            case CHAR:
            case VARCHAR:
            case TEXT:
                if (!meta.isNotNull() && (meta.getField().get(entity)) == null) {
                    ps.setString(index, null);
                } else {
                    ps.setString(index, meta.getField().get(entity).toString());
                }
                break;
            case DATE:
                if (!meta.isNotNull() && (meta.getField().get(entity)) == null) {
                    ps.setDate(index, null);
                } else {
                    Object value = meta.getField().get(entity);
                    if (value instanceof LocalDate) {
                        java.sql.Date date = java.sql.Date.valueOf((LocalDate) value);
                        ps.setDate(index, date);
                    } else {
                        ps.setDate(index, new java.sql.Date(((Date) (meta.getField().get(entity))).getTime()));
                    }
                }
                break;
            case DATETIME:
                if (!meta.isNotNull() && (meta.getField().get(entity)) == null) {
                    ps.setTimestamp(index, null);
                } else {
                    Object value = meta.getField().get(entity);
                    if (value instanceof LocalDateTime) {
                        Timestamp timestamp = Timestamp.valueOf((LocalDateTime) value);
                        ps.setTimestamp(index, timestamp);
                    } else {
                        Date date = (Date) value;
                        ps.setTimestamp(index, new Timestamp(date.getTime()));
                    }
                }
                break;
            case BLOB:
                if (!meta.isNotNull() && (meta.getField().get(entity) == null)) {
                    ps.setBytes(index, null);
                } else {
                    ps.setBytes(index, (byte[]) (meta.getField().get(entity)));
                }
                break;
            default: {
                ps.setString(index, GsonUtils.toJson(meta.getField().get(entity)));
            }
        }
    }

    @Override
    public void update(Collection<T> entities) {
        if (entities == null || entities.isEmpty()) {
            return;
        }
        Map<String, List<T>> map = groupingByTableName(metaData, entities);
        map.forEach((tableName, updates) -> {
            String sql = sqlAssembly.generateUpdateSql(tableName, metaData);
            batchUpdate(sql, updates);
        });
    }

    /**
     * 根据表名分组
     *
     * @param metaData
     * @param entities
     * @return
     */
    private Map<String, List<T>> groupingByTableName(MetaData metaData, Collection<T> entities) {
        return entities.stream().collect(Collectors.groupingBy(entity -> sqlAssembly.routingTable(metaData, entity)));
    }

    private void batchUpdate(String sql, Collection<T> entities) {
        if (log.isDebugEnabled()) {
            log.debug(sql);
        }
        long t = System.currentTimeMillis();
        Connection connection = null;
        PreparedStatement ps = null;
        try {
            connection = dataBaseAccessor.getConnection();
            connection.setAutoCommit(false);
            ps = connection.prepareStatement(sql);
            for (T entity : entities) {
                prepareStatementUpdate(ps, entity);
                ps.addBatch();
            }
            ps.executeBatch();
            connection.commit();
        } catch (Exception e) {
            throw new RuntimeException(String.format("批量修改数据 [%s]sql:%s 异常!", entityType.getSimpleName(), sql), e);
        } finally {
            try {
                if (ps != null) {
                    ps.close();
                }
            } catch (SQLException e) {
                log.error("close statement failed", e);
            }
            try {
                if (connection != null) {
                    connection.setAutoCommit(true);
                    connection.close();
                }
            } catch (SQLException e) {
                log.error("close connection failed", e);
            }
            logIfSlowQuery(sql, System.currentTimeMillis() - t);
        }
    }
}
