package com.ayjs.mxzg.repository.persister;

import cn.hutool.core.collection.CollectionUtil;
import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.meta.ColumnMeta;
import com.ayjs.mxzg.common.persistence.meta.IndexMeta;
import com.ayjs.mxzg.common.persistence.meta.TableMeta;
import com.ayjs.mxzg.common.persistence.repository.DataBaseAccessor;
import com.ayjs.mxzg.common.util.GJsonUtils;
import com.ayjs.mxzg.repository.manager.TableMetaManager;
import com.google.common.collect.Lists;
import lombok.Getter;
import lombok.extern.slf4j.Slf4j;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 * @Author: CWJ
 * @Date: 2020/8/20
 **/
@Slf4j
public class MergeRepository {

    @Getter
    protected DataBaseAccessor dataBaseAccessor;

    @Getter
    private String dbName;

    public MergeRepository(DataBaseAccessor dataBaseAccessor, String dbName) {
        this.dataBaseAccessor = dataBaseAccessor;
        this.dbName = dbName;
    }

    private String buildUpdateSQL(AbstractEntity entity) {
        TableMeta meta = TableMetaManager.getInstance().get(entity.getClass());
        StringBuilder sb = new StringBuilder();
        sb.append("UPDATE `").append(meta.getRealName(entity)).append("` SET ");
        for (int i = 0; i < meta.getColumns().size(); i++) {
            ColumnMeta col = meta.getColumns().get(i);
            if (!col.isReadOnly() && !col.isPk()) {
                sb.append("`").append(col.getName()).append("` = ?").append(",");
            }
        }
        String withToken = sb.toString();
        String removeLast = withToken.substring(0, withToken.length() - 1);
        sb = new StringBuilder();
        sb.append(removeLast);
        sb.append(" WHERE `").append(meta.getPk().getName()).append("` = ?");
        return sb.toString();
    }

    private void prepareStatementUpdate(PreparedStatement ps, AbstractEntity entity) throws Exception {
        TableMeta meta = TableMetaManager.getInstance().get(entity.getClass());
        int index = 1;
        for (ColumnMeta col : meta.getColumns()) {
            if (!col.isReadOnly() && !col.isPk()) {
                prepareStatement(ps, index++, col, entity);
            }
        }
        prepareStatement(ps, index, meta.getPk(), entity);
    }

    private String buildWhereSQL(Map<String, Object> options, TableMeta meta) {
        // 使用索引
        int counter = 0;
        IndexMeta used = null;
        for (IndexMeta i : meta.getIndexes().values()) {
            int c = 0;
            for (String fieldName : options.keySet()) {
                ColumnMeta col = meta.getColumnMetaByFieldName(fieldName);
                if (col == null) {
                    throw new RuntimeException("filed[" + fieldName + "] not found in entity meta[" + meta.getName() + "]");
                }
                if (i.getColumns().contains(col.getName())) {
                    c++;
                }
            }
            if (c > counter) {
                counter = c;
                used = i;
            }
        }

        // 没有索引或无法使用索引时，乱序生成where语句
        Iterator<String> it;
        if (used == null) {
            it = options.keySet().iterator();
            if (log.isWarnEnabled()) {
                StringBuilder sb = new StringBuilder();
                options.keySet().forEach(n -> sb.append(n).append(","));
                log.warn("no index found when query " + meta.getName() + " with options:" + sb.toString());
            }
        } else {
            List<String> list = new ArrayList<>();
            Set<String> clone = new HashSet<>(options.keySet());
            for (String colName : used.getColumns()) {
                if (options.containsKey(colName)) {
                    list.add(colName);
                    clone.remove(colName);
                }
            }
            list.addAll(clone);
            it = list.iterator();
        }
        StringBuilder sb = new StringBuilder();
        if (it.hasNext()) {
            sb.append(" WHERE ");
        }
        while (it.hasNext()) {
            String colName = it.next();
            Object value = options.get(colName);
            ColumnMeta col = meta.getColumnMetaByFieldName(colName);
            sb.append("`").append(col.getName()).append("` = ").append(col.getValue(value));
            if (it.hasNext()) {
                sb.append(" AND ");
            }
        }
        return sb.toString();
    }

    private String buildSelectSQL2(Map<String, Object> option, TableMeta meta) {
        StringBuilder sb = new StringBuilder();
        sb.append("SELECT ");
        for (int i = 0; i < meta.getColumns().size(); i++) {
            ColumnMeta col = meta.getColumns().get(i);
            sb.append("`").append(col.getName()).append("`");
            if (i < meta.getColumns().size() - 1) {
                sb.append(",");
            }
        }
        if (meta.getClusterBy() == null) {
            sb.append(" FROM `").append(meta.getName()).append("` ");
        } else {
            Object cluster = option.get(meta.getClusterBy().getField().getName());
            if (cluster == null) {
                throw new RuntimeException("cluster needed when query table");
            }
            sb.append(" FROM `")
                    .append(meta.getName())
                    .append("_").append(Math.abs(cluster.hashCode() % meta.getCluster()))
                    .append("`");
        }
        if (option != null) {
            sb.append(buildWhereSQL(option, meta));
        }
        return sb.toString();

    }


    private <T extends AbstractEntity> List<T> parse(TableMeta meta, List<Map<String, Object>> rs, Class<T> clz) throws SQLException {
        List<T> list = new ArrayList<>();
        try {
            for (Map<String, Object> map : rs) {
                T t = (T) meta.getClazz().newInstance();
                for (ColumnMeta col : meta.getColumns()) {
                    if (map.containsKey(col.getName())) {
                        col.cast(t, map.get(col.getName()));
                    }
                }
                list.add(t);
            }
        } catch (Exception e) {
            throw new SQLException("build entity from result set failed", e);
        }
        return list;
    }

    public <T extends AbstractEntity> List<T> listAll(Class<T> clz) {
        return list(null, clz);
    }

    public <T extends AbstractEntity> T get(Object id, Class<T> clz) {
        TableMeta meta = TableMetaManager.getInstance().get(clz);
        String sql = buildSelectSQL(id, meta);
        try {
            List<T> list = parse(meta, dataBaseAccessor.query(sql), clz);
            if (list == null || list.size() == 0) {
                return null;
            }
            return (T) list.get(0);
        } catch (SQLException e) {
            throw new RuntimeException(e.getMessage(), e);
        }
    }

    private String buildSelectSQL(Object id, TableMeta meta) {
        if (meta.getClusterBy() != null) {
            throw new RuntimeException("can not query cluster table[" + meta.getName() + "] by id");
        }

        StringBuilder sb = new StringBuilder();
        sb.append("SELECT ");
        for (int i = 0; i < meta.getColumns().size(); i++) {
            ColumnMeta col = meta.getColumns().get(i);
            sb.append("`").append(col.getName()).append("`");
            if (i < meta.getColumns().size() - 1) {
                sb.append(",");
            }
        }
        sb.append(" FROM `").append(meta.getName())
                .append("` WHERE `").append(meta.getPk().getName())
                .append("` = ").append(meta.getPk().getValue(id));
        return sb.toString();
    }


    public <T extends AbstractEntity> List<T> list(Map<String, Object> options, Class<T> clz) {
        try {
            TableMeta meta = TableMetaManager.getInstance().get(clz);
            String sql = buildSelectSQL2(options, meta);
            return parse(meta, dataBaseAccessor.query(sql), clz);
        } catch (SQLException e) {
            throw new RuntimeException(e.getMessage(), e);
        }
    }

    public <T extends AbstractEntity> void update(List<T> entities) {
        if (CollectionUtil.isEmpty(entities)) {
            return;
        }
        T entity = entities.get(0);
        String sql = buildUpdateSQL(entity);
        if (log.isDebugEnabled()) {
            log.debug("sql:{}, entities:{}", sql, GJsonUtils.toJson(entities));
        }

        Connection connection = null;
        PreparedStatement ps = null;
        try {
            connection = dataBaseAccessor.getConnection();
            connection.setAutoCommit(false);
            ps = connection.prepareStatement(sql);
            for (T e : entities) {
                prepareStatementUpdate(ps, e);
                ps.addBatch();
            }
            ps.executeBatch();
            connection.commit();
        } catch (Exception e) {
            throw new RuntimeException(e.getMessage(), e);
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

        }
    }

    public <T extends AbstractEntity> void remove(List<T> entities) {
        if (entities == null || entities.size() == 0) {
            return;
        }
        T entity = entities.get(0);
        TableMeta meta = TableMetaManager.getInstance().get(entity.getClass());
        String sql = buildDeleteSQL(meta, entity);
        if (log.isDebugEnabled()) {
            log.debug(sql);
        }

        Connection connection = null;
        PreparedStatement ps = null;
        try {
            connection = dataBaseAccessor.getConnection();
            connection.setAutoCommit(false);
            ps = connection.prepareStatement(sql);
            for (T e : entities) {
                prepareStatement(ps, 1, meta.getPk(), e);
                ps.addBatch();
            }
            ps.executeBatch();
            connection.commit();
        } catch (Exception e) {
            throw new RuntimeException(e.getMessage(), e);
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
        }
    }

    public <T extends AbstractEntity> void add(List<T> entities) {
        if (entities == null || entities.size() == 0) {
            return;
        }
        T entity = entities.get(0);
        TableMeta meta = TableMetaManager.getInstance().get(entity.getClass());
        String sql = buildInsertSQL(entity, meta);


        if (log.isDebugEnabled()) {
            log.debug(sql);
        }
        Connection connection = null;
        PreparedStatement ps = null;
        try {
            connection = dataBaseAccessor.getConnection();
            connection.setAutoCommit(false);
            ps = connection.prepareStatement(sql);
            for (T e : entities) {
                prepareStatementInsert(ps, e, meta);
                ps.addBatch();
            }
            ps.executeBatch();
            connection.commit();
        } catch (Exception e) {
            throw new RuntimeException(e.getMessage(), e);
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

        }
    }


    private String buildInsertSQL(AbstractEntity entity, TableMeta meta) {
        StringBuilder sb = new StringBuilder();
        sb.append("INSERT INTO `");
        sb.append(meta.getRealName(entity));
        sb.append("` (");
        StringBuilder vTemp = new StringBuilder();
        StringBuilder cTemp = new StringBuilder();
        for (int i = 0; i < meta.getColumns().size(); i++) {
            ColumnMeta col = meta.getColumns().get(i);
            if (!col.isPk() || !col.isAuto()) {
                cTemp.append("`").append(col.getName()).append("`, ");
                vTemp.append("?, ");
            }
        }
        sb.append(cTemp.subSequence(0, cTemp.length() - 2));
        sb.append(") VALUE (").append(vTemp.subSequence(0, vTemp.length() - 2)).append(")");
        return sb.toString();
    }

    private void prepareStatementInsert(PreparedStatement ps, AbstractEntity entity, TableMeta meta) throws Exception {
        int index = 1;
        for (int i = 0; i < meta.getColumns().size(); i++) {
            ColumnMeta col = meta.getColumns().get(i);
            if (!col.isPk() || !col.isAuto()) {
                prepareStatement(ps, index++, col, entity);
            }
        }
    }

    protected void prepareStatement(PreparedStatement ps, int index, ColumnMeta meta, AbstractEntity entity)
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
                ps.setString(index, GJsonUtils.toJson(meta.getField().get(entity)));
            }
        }
    }

    private <T extends AbstractEntity> String buildDeleteSQL(TableMeta meta, T entity) {
        return "DELETE FROM `" + meta.getRealName(entity) + "` WHERE `" + meta.getPk().getName() + "` = ?";
    }

    public void truncateAll(Class<? extends AbstractEntity> clz) {
        TableMeta meta = TableMetaManager.getInstance().get(clz);
        List<String> tableNames = meta.getTruncateTableName();
        String sql = "truncate " + tableNames.get(0);
        if (log.isDebugEnabled()) {
            log.debug(sql);
        }
        Connection connection = null;
        PreparedStatement ps = null;
        try {
            connection = dataBaseAccessor.getConnection();
            connection.setAutoCommit(false);
            ps = connection.prepareStatement(sql);
            for (String tableName : tableNames) {
                ps.addBatch("truncate " + tableName);
//                prepareStatementUpdate(ps, e);
                ps.addBatch();
            }
            ps.executeBatch();
            connection.commit();
        } catch (Exception e) {
            throw new RuntimeException(e.getMessage(), e);
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

        }
    }

    public List<String> queryTableName() {
        List<String> result = Lists.newArrayList();
        try {
            List<Map<String, Object>> show_tables = dataBaseAccessor.query("show tables");
            show_tables.forEach(tableNameMap -> {
                tableNameMap.values().forEach(tableName -> result.add(String.valueOf(tableName)));
            });
        } catch (Exception e) {
            throw new RuntimeException(e.getMessage(), e);
        }
        return result;
    }

    public String buildCreateSQL(TableMeta meta) {
        StringBuilder sb = new StringBuilder();
        sb.append("CREATE TABLE IF NOT EXISTS `").append(meta.getName()).append("`(\n");
        // columns
        for (ColumnMeta columnMeta : meta.getColumns()) {
            sb.append(columnMeta.buildCreateSQL()).append(",");
            sb.append("\n");
        }
        // pk
        sb.append("PRIMARY KEY (`").append(meta.getPk().getName()).append("`)");
        // index
        if (meta.getIndexes().size() > 0) {
            sb.append(",\n");
            int p = 0;
            for (IndexMeta idx : meta.getIndexes().values()) {
                sb.append(idx.buildCreateSQL());
                if (p < meta.getIndexes().size() - 1) {
                    sb.append(",\n");
                }
                p++;
            }
        } else {
            sb.append("\n");
        }
        sb.append(")");
        if (!"".equals(meta.getCharset())) {
            sb.append(" DEFAULT CHARACTER SET ").append(meta.getCharset());
        }
        sb.append(" COMMENT='").append(meta.getComment()).append("'\n");
        return sb.toString();
    }

    public void execute(String sql) throws SQLException {
        Connection connection = null;
        Statement statement = null;
        try {
            connection = dataBaseAccessor.getConnection();
            statement = connection.createStatement();
            statement.execute(sql);
        } finally {
            if (statement != null) {
                statement.close();
            }
            if (connection != null) {
                connection.close();
            }
        }
    }
}
