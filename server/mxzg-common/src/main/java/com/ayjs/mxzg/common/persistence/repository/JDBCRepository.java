package com.ayjs.mxzg.common.persistence.repository;


import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.CRepository;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.common.persistence.generator.IdGenerator;
import com.ayjs.mxzg.common.persistence.generator.IdGeneratorRegistry;
import com.ayjs.mxzg.common.persistence.meta.ColumnMeta;
import com.ayjs.mxzg.common.persistence.meta.IndexMeta;
import com.ayjs.mxzg.common.persistence.meta.TableMeta;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.gson.GsonUtils;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;

import java.lang.reflect.ParameterizedType;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Set;
import java.util.concurrent.ScheduledExecutorService;

/**
 * 数据库仓储
 */
@Slf4j
@CRepository(source = "data")
public abstract class JDBCRepository<T extends AbstractEntity> implements IRepository<T> {


    protected final DataBaseAccessor dataBaseAccessor;

    protected final TableMeta meta;

    private int slowLog;

    protected final ScheduledExecutorService pool;

    @Autowired
    private IdGeneratorRegistry idGeneratorRegistry;

    @SuppressWarnings("unchecked")
    protected Class<T> getClassOfEntity() {
        return (Class<T>) ((ParameterizedType) (getClass().getGenericSuperclass())).getActualTypeArguments()[0];
    }

    private CRepository _getAnnotation(Class<?> clazz) {
        CRepository repository = clazz.getAnnotation(CRepository.class);
        if (repository != null) {
            return repository;
        }
        if (clazz.getSuperclass() != null) {
            return _getAnnotation(clazz.getSuperclass());
        } else {
            return null;
        }
    }

    protected CRepository getAnnotation() {
        return _getAnnotation(this.getClass());
    }

    protected JDBCRepository() {
        CRepository repository = getAnnotation();
        this.dataBaseAccessor = DataBaseAccessorManager.getInstance().get(repository.source());
        this.meta = TableMeta.parse(getClassOfEntity());
        this.slowLog = dataBaseAccessor.getSlowLog();
        this.pool = dataBaseAccessor.getPool();
        if (meta.isAutoCreate()) {
            try {
                fixTable();
            } catch (Exception e) {
                log.error("fix table failed", e);
            }
        }
    }

    private Object nextId() {
        IdGenerator idGenerator = idGeneratorRegistry.getIdGenerator(meta.getClazz());
        Asserts.notNull(idGenerator, () -> String.format("{%s} IdGenerator不存在", meta.getName()));
        return idGenerator.nextId();
    }

    protected boolean needSetId() {
        return idGeneratorRegistry.getIdGenerator(meta.getClazz()) != null;
    }

    protected void setId(T entity) {
        meta.getPk().cast(entity, nextId());
    }

    private void diffEntityBetweenTable(TableMeta meta, TableMeta orig) throws SQLException {
        //字段
        Set<String> mark = new HashSet<>();
        for (ColumnMeta columnMeta : meta.getColumns()) {
            mark.add(columnMeta.getName());
            ColumnMeta column = orig.getColumnMetaByColumnName(columnMeta.getName());
            //新增
            if (column == null) {
                dataBaseAccessor.update("ALTER TABLE `" + orig.getName() + "` ADD COLUMN " + columnMeta.buildCreateSQL());
            } else {
                //列依然存在，但有变动
                if (!column.isSame(columnMeta)) {
                    //列依然存在，但有变动
                    dataBaseAccessor.update("ALTER TABLE `" + orig.getName() + "` MODIFY COLUMN " + columnMeta.buildCreateSQL());
                }
            }
        }

        //索引
        mark.clear();
        for (IndexMeta indexMeta : meta.getIndexes().values()) {
            mark.add(indexMeta.getName());
            IndexMeta index = orig.getIndexes().get(indexMeta.getName());
            if (index == null) {
                dataBaseAccessor.update("ALTER TABLE `" + orig.getName() + "` ADD " + indexMeta.buildCreateSQL());
            } else {
                if (!index.isSame(indexMeta)) {
                    dataBaseAccessor.update("DROP INDEX `" + indexMeta.getName() + "` on `" + meta.getName() + "`");
                    dataBaseAccessor.update("ALTER TABLE `" + meta.getName() + "` ADD " + indexMeta.buildCreateSQL());
                }
            }
        }
        for (String indexName : orig.getIndexes().keySet()) {
            if (!mark.contains(indexName)) {
                dataBaseAccessor.update("DROP INDEX `" + indexName + "` on `" + orig.getName() + "`");
            }
        }
    }

    private List<String> buildCreateSQL(List<Integer> specialCluster) {
        List<String> resultList = new ArrayList<>();
        if (meta.getClusterBy() == null) {
            resultList.add(buildCreateSQL(meta.getName()));
            return resultList;
        }
        for (int i = 0; i < meta.getCluster(); i++) {//已存在的则表示需要判断性的创建
            if (specialCluster.contains(i)) {
                continue;
            }
            resultList.add(buildCreateSQL(meta.getName() + "_" + i));
        }
        return resultList;
    }

    private void fixTable() throws Exception {
        Table annotation = getClassOfEntity().getAnnotation(Table.class);
        if (!annotation.autoCreate()) {
            return;
        }
        List<Map<String, Object>> list = dataBaseAccessor.query("SHOW TABLES LIKE \"" + meta.getName() + "%\"");
        Set<String> tables = new HashSet<>();
        for (Map<String, Object> map : list) {
            for (Object v : map.values()) {
                tables.add(v.toString().toLowerCase());
            }
        }
        //分表意味着一对多.所以需要反过来判定.
        List<Integer> specialClusters = new ArrayList<>();
        if (meta.getCluster() > 0) {
            //分表需要整体调整
            for (int i = 0; i < meta.getCluster(); i++) {
                if (tables.contains(meta.getName() + "_" + i)) {
                    TableMeta orig = TableMeta.getTableFromDB(meta.getName() + "_" + i, dataBaseAccessor);
                    diffEntityBetweenTable(meta, orig);
                    specialClusters.add(i);
                }
            }

            if (specialClusters.size() < meta.getCluster()) {
                List<String> sql = buildCreateSQL(specialClusters);
                for (String s : sql) {
                    dataBaseAccessor.update(s);
                }
            }
        } else {
            if (tables.contains(meta.getName())) {
                TableMeta orig = TableMeta.getTableFromDB(meta.getName(), dataBaseAccessor);
                diffEntityBetweenTable(meta, orig);
            } else {
                List<String> sql = buildCreateSQL(specialClusters);
                for (String s : sql) {
                    dataBaseAccessor.update(s);
                }
            }
        }
    }

    protected String buildCreateSQL(String tableName) {
        StringBuilder sb = new StringBuilder();
        sb.append("CREATE TABLE IF NOT EXISTS `").append(tableName).append("`(\n");
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

    private String buildInsertSQL(T entity) {
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

    protected void prepareStatement(PreparedStatement ps, int index, ColumnMeta meta, T entity)
            throws IllegalAccessException, IllegalArgumentException, SQLException {
        Object tempValue = meta.getField().get(entity);
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
                if (!meta.isNotNull() && tempValue == null) {
                    ps.setString(index, null);
                } else {
                    if (Objects.isNull(tempValue)) {
                        ps.setString(index, null);
                        log.error("column can not null.field:{}", meta.getName());
                    } else {
                        ps.setString(index, tempValue.toString());
                    }
                }
                break;
            case DATE:
                if (!meta.isNotNull() && tempValue == null) {
                    ps.setDate(index, null);
                } else {
                    if (Objects.isNull(tempValue)) {
                        ps.setDate(index, null);
                        log.error("column can not null.field:{}", meta.getName());
                    } else {
                        Object value = tempValue;
                        if (value instanceof LocalDate) {
                            ps.setObject(index, value);
                        } else {
                            ps.setDate(index, new java.sql.Date(((Date) tempValue).getTime()));
                        }
                    }
                }
                break;
            case DATETIME:
                if (!meta.isNotNull() && tempValue == null) {
                    ps.setTimestamp(index, null);
                } else {
                    if (Objects.isNull(tempValue)) {
                        ps.setTimestamp(index, null);
                        log.error("column can not null.field:{}", meta.getName());
                    } else {
                        Object value = tempValue;
                        if (value instanceof LocalDateTime) {
                            Timestamp timestamp = Timestamp.valueOf((LocalDateTime) value);
                            ps.setTimestamp(index, timestamp);
                        } else {
                            Date date = (Date) value;
                            ps.setTimestamp(index, new Timestamp(date.getTime()));
                        }
                    }
                }
                break;
            case BLOB:
                if (!meta.isNotNull() && (tempValue == null)) {
                    ps.setBytes(index, null);
                } else {
                    if (Objects.isNull(tempValue)) {
                        ps.setBytes(index, null);
                        log.error("column can not null.field:{}", meta.getName());
                    } else {
                        ps.setBytes(index, (byte[]) tempValue);
                    }
                }
                break;
            default: {
                if (Objects.isNull(tempValue)) {
                    ps.setString(index, null);
                    log.error("column can not null.field:{}", meta.getName());
                } else {
                    ps.setString(index, GsonUtils.toJson(tempValue));
                }
            }
        }
    }

    private void prepareStatementInsert(PreparedStatement ps, T entity) throws Exception {
        int index = 1;
        for (int i = 0; i < meta.getColumns().size(); i++) {
            ColumnMeta col = meta.getColumns().get(i);
            if (col.isPk() && needSetId() && !col.isAuto()) {
                setId(entity);
            }
            if (!col.isPk() || !col.isAuto()) {
                prepareStatement(ps, index++, col, entity);
            }
        }
    }

    private String buildDeleteSQL(TableMeta meta, T entity) {
        return "DELETE FROM `" + meta.getRealName(entity) + "` WHERE `" + meta.getPk().getName() + "` = ?";
    }

    private String buildUpdateSQL(T entity) {
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

    private void prepareStatementUpdate(PreparedStatement ps, T entity) throws Exception {
        int index = 1;
        for (ColumnMeta col : meta.getColumns()) {
            if (!col.isReadOnly() && !col.isPk()) {
                prepareStatement(ps, index++, col, entity);
            }
        }
        prepareStatement(ps, index, meta.getPk(), entity);
    }

    private String buildSelectSQL(Object id) {
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

    private String buildWhereSQL(Map<String, Object> options) {
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

    private String buildSelectSQL2(Map<String, Object> option) {
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
            sb.append(buildWhereSQL(option));
        }
        return sb.toString();

    }

    @SuppressWarnings("unchecked")
    private List<T> parse(TableMeta meta, List<Map<String, Object>> rs) throws SQLException {
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

    @Override
    public void add(T entity) {

        String sql = buildInsertSQL(entity);
        if (log.isDebugEnabled()) {
            log.debug(sql);
        }
        Connection connection = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        long t = System.currentTimeMillis();
        try {
            connection = dataBaseAccessor.getConnection();
            if (meta.getPk().isAuto()) {
                ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
                prepareStatementInsert(ps, entity);
                ps.executeUpdate();
                rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    meta.getPk().cast(entity, rs.getLong(1));
                } else {
                    throw new SQLException("get generated keys from db failed");
                }
            } else {
                ps = connection.prepareStatement(sql);
                prepareStatementInsert(ps, entity);
                ps.executeUpdate();
            }
        } catch (Exception e) {
            throw new RuntimeException(e.getMessage(), e);
        } finally {
            if (rs != null) {
                try {
                    rs.close();
                } catch (SQLException e) {
                    log.error("close result failed", e);
                }
            }
            if (ps != null) {
                try {
                    ps.close();
                } catch (SQLException e) {
                    log.error("close statement failed", e);
                }
            }
            if (connection != null) {
                try {
                    connection.close();
                } catch (SQLException e) {
                    log.error("close connection failed", e);
                }
            }
            t = System.currentTimeMillis() - t;
            if (t > slowLog) {
                if (log.isWarnEnabled()) {
                    log.warn("slow sql [" + t + "]" + sql);
                }
            }
        }
    }


    @Override
    public void add(List<T> entities) {
        if (entities == null || entities.size() == 0) {
            return;
        }
        T entity = entities.get(0);
        String sql = buildInsertSQL(entity);

        if (log.isDebugEnabled()) {
            log.debug(sql);
        }
        Connection connection = null;
        PreparedStatement ps = null;
        long t = System.currentTimeMillis();
        try {
            connection = dataBaseAccessor.getConnection();
            connection.setAutoCommit(false);
            ps = connection.prepareStatement(sql);
            for (T e : entities) {
                prepareStatementInsert(ps, e);
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
            t = System.currentTimeMillis() - t;
            if (t > slowLog) {
                if (log.isWarnEnabled()) {
                    log.warn("slow sql [" + t + "]" + sql);
                }
            }
        }
    }

    @Override
    public void remove(T entity) {
        String sql = buildDeleteSQL(meta, entity);
        if (log.isDebugEnabled()) {
            log.debug(sql);
        }

        Connection connection = null;
        PreparedStatement ps = null;
        long t = System.currentTimeMillis();
        try {
            connection = dataBaseAccessor.getConnection();
            ps = connection.prepareStatement(sql);
            prepareStatement(ps, 1, meta.getPk(), entity);
            ps.executeUpdate();
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
                    connection.close();
                }
            } catch (SQLException e) {
                log.error("close connection failed", e);
            }
            t = System.currentTimeMillis() - t;
            if (t > slowLog) {
                if (log.isWarnEnabled()) {
                    log.warn("slow sql [" + t + "]" + sql);
                }
            }
        }
    }

    @Override
    public void remove(List<T> entities) {
        if (entities == null || entities.size() == 0) {
            return;
        }
        T entity = entities.get(0);
        String sql = buildDeleteSQL(meta, entity);
        if (log.isDebugEnabled()) {
            log.debug(sql);
        }

        Connection connection = null;
        PreparedStatement ps = null;
        long t = System.currentTimeMillis();
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
            t = System.currentTimeMillis() - t;
            if (t > 100) {
                if (log.isWarnEnabled()) {
                    log.warn("slow sql [" + t + "]" + sql);
                }
            }
        }
    }

    @SuppressWarnings("unchecked")
    @Override
    public T get(Object id) {
        String sql = buildSelectSQL(id);
        try {
            List<T> list = parse(meta, dataBaseAccessor.query(sql));
            if (list == null || list.size() == 0) {
                return null;
            }
            return list.get(0);
        } catch (SQLException e) {
            throw new RuntimeException(e.getMessage(), e);
        }
    }

    @SuppressWarnings("unchecked")
    @Override
    public List<T> listAll() {
        return list(null);
    }

    @SuppressWarnings("unchecked")
    @Override
    public List<T> list(Map<String, Object> options) {
        try {
            String sql = buildSelectSQL2(options);
            return parse(meta, dataBaseAccessor.query(sql));
        } catch (SQLException e) {
            throw new RuntimeException(e.getMessage(), e);
        }
    }

    @Override
    public T get(String field, Object value) {
        List<T> list = list(field, value);
        if (list == null || list.size() == 0) {
            return null;
        }
        return list.get(0);
    }

    @Override
    public List<T> list(String field, Object value) {
        Map<String, Object> options = new HashMap<>();
        options.put(field, value);
        return list(options);
    }

    @Override
    public void update(T entity) {
        String sql = buildUpdateSQL(entity);
        if (log.isDebugEnabled()) {
            log.debug(sql);
        }

        Connection connection = null;
        PreparedStatement ps = null;
        long t = System.currentTimeMillis();
        try {
            connection = dataBaseAccessor.getConnection();
            ps = connection.prepareStatement(sql);
            prepareStatementUpdate(ps, entity);
            ps.executeUpdate();
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
                    connection.close();
                }
            } catch (SQLException e) {
                log.error("close connection failed", e);
            }
            t = System.currentTimeMillis() - t;
            if (t > slowLog) {
                if (log.isWarnEnabled()) {
                    log.warn("slow sql [" + t + "]" + sql);
                }
            }
        }
    }

    @Override
    public void update(List<T> entities) {
        if (entities == null || entities.size() == 0) {
            return;
        }
        T entity = entities.get(0);
        String sql = buildUpdateSQL(entity);
        if (log.isDebugEnabled()) {
            log.debug("sql:{}, entities:{}", sql, GsonUtils.toJson(entities));
        }

        Connection connection = null;
        PreparedStatement ps = null;
        long t = System.currentTimeMillis();
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
            t = System.currentTimeMillis() - t;
            if (t > 100) {
                if (log.isWarnEnabled()) {
                    log.warn("slow sql [" + t + "]" + sql);
                }
            }
        }
    }

    @Override
    public void truncateAll() {
        List<String> tableNames = meta.getTruncateTableName();
        String sql = "truncate " + tableNames.get(0);
        if (log.isDebugEnabled()) {
            log.debug(sql);
        }
        Connection connection = null;
        PreparedStatement ps = null;
        long t = System.currentTimeMillis();
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
            t = System.currentTimeMillis() - t;
            if (t > 100) {
                if (log.isWarnEnabled()) {
                    log.warn("slow sql [" + t + "]" + sql);
                }
            }
        }
    }

}
