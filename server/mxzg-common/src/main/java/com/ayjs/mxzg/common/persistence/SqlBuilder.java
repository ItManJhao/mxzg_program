package com.ayjs.mxzg.common.persistence;

import com.ayjs.mxzg.common.persistence.meta.ColumnMeta;
import com.ayjs.mxzg.common.persistence.meta.IndexMeta;
import com.ayjs.mxzg.common.persistence.meta.TableMeta;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Set;

/**
 * sql生成
 */
@Slf4j
public class SqlBuilder {
    /**
     * 查看表
     *
     * @param tableName
     * @return
     */
    public static String showTables(String tableName) {
        return new StringBuilder("SHOW TABLES LIKE ").append("'").append(tableName).append("%'").toString();
    }

    /**
     * 查询当前区最大主键id
     *
     * @param tableName
     * @param idName
     * @param serverId
     * @return
     */
    public static String selectMaxId(String tableName, String idName, int serverId) {
        StringBuilder sql = new StringBuilder("SELECT ")
                .append(formatName(idName)).append(" FROM ")
                .append(formatName(tableName)).append(" WHERE ")
                .append(formatName(idName)).append(" LIKE '")
                .append(serverId).append("%' ORDER BY ")
                .append(formatName(idName)).append(" DESC LIMIT 1");
        return sql.toString();
    }

    /**
     * 查询表主键最大值
     *
     * @param tableName
     * @param idName
     * @return
     */
    public static String selectMaxId(String tableName, String idName) {
        StringBuilder sql = new StringBuilder("SELECT ")
                .append(formatName(idName)).append(" FROM ")
                .append(formatName(tableName)).append(" ORDER BY ")
                .append(formatName(idName)).append(" DESC LIMIT 1");
        return sql.toString();
    }

    /**
     * 格式化字段表名
     *
     * @param name
     * @return
     */
    public static String formatName(String name) {
        return "`" + name + "`";
    }

    /**
     * 删除表数据
     *
     * @param tableName
     * @param key
     * @param id
     * @return
     */
    public static <K> String delete(String tableName, String key, K id) {
        StringBuilder sb = new StringBuilder("DELETE FROM ").append(formatName(tableName)).append(" WHERE ");
        sb.append(formatName(key)).append(" = ").append(formatValue(id));
        return sb.toString();
    }

    public static <K> String psDelete(String tableName, List<ColumnMeta> ids) {
        StringBuilder sb = new StringBuilder("DELETE FROM ").append(formatName(tableName)).append(" WHERE ");
        for (int i = 0; i < ids.size(); i++) {
            if (i > 0) {
                sb.append(" AND ");
            }
            sb.append(formatName(ids.get(i).getName())).append("= ? ");
        }
        return sb.toString();
    }

    /**
     * 删除表数据 预编译
     *
     * @param tableName
     * @param key
     * @return
     */
    public static String psDelete(String tableName, String key) {
        StringBuilder sb = new StringBuilder("DELETE FROM ").append(formatName(tableName)).append(" WHERE ");
        sb.append(formatName(key)).append(" = ?");
        return sb.toString();
    }

    /**
     * 删除所有
     *
     * @param tableName
     * @return
     */
    public static String deleteAll(String tableName) {
        return "DELETE FROM " + formatName(tableName);
    }

    /**
     * 构建分片名称
     *
     * @param tableName
     * @param shardingId
     * @return
     */
    public static String buildShardingName(String tableName, Object shardingId) {
        return tableName + "_" + shardingId;
    }

    /**
     * 根据id查询
     *
     * @param tbName
     * @param key
     * @param id
     * @return
     */
    public static <K> String select(String tbName, String key, K id) {
        StringBuilder sb = new StringBuilder("SELECT * FROM ").append(formatName(tbName)).append(" WHERE ");
        sb.append(formatName(key)).append("=").append(formatValue(id));
        return sb.toString();
    }

    public static <K> String psSelect(String tbName, List<ColumnMeta> ids) {
        StringBuilder sb = new StringBuilder("SELECT * FROM ").append(formatName(tbName)).append(" WHERE ");
        for (int i = 0; i < ids.size(); i++) {
            if (i > 0) {
                sb.append(" AND ");
            }
            sb.append(formatName(ids.get(i).getName())).append("= ? ");
        }
        return sb.toString();
    }

    /**
     * 格式化参数值
     *
     * @param value
     * @return
     */
    private static String formatValue(Object value) {
        StringBuilder sb = new StringBuilder();
        if (value instanceof String) {
            sb.append("'").append(value).append("'");
        } else {
            sb.append(value);
        }
        return sb.toString();
    }

    /**
     * 查询所有
     *
     * @param tableName
     * @return
     */
    public static String selectAll(String tableName) {
        return new StringBuilder("SELECT * FROM ").append(formatName(tableName)).toString();
    }

    /**
     * 条件查询
     *
     * @param tableName
     * @param meta
     * @param options
     * @return
     */
    public static String list(String tableName, TableMeta meta, Map<String, Object> options) {
        StringBuilder sb = new StringBuilder();
        sb.append("SELECT ");
        for (int i = 0; i < meta.getColumns().size(); i++) {
            ColumnMeta col = meta.getColumns().get(i);
            sb.append("`").append(col.getName()).append("`");
            if (i < meta.getColumns().size() - 1) {
                sb.append(",");
            }
        }
        sb.append(" FROM `").append(tableName).append("` ");
        sb.append(where(tableName, meta, options));
        return sb.toString();
    }

    private static String where(String tableName, TableMeta meta, Map<String, Object> options) {
        // 使用索引
        int counter = 0;
        IndexMeta used = null;
        for (IndexMeta i : meta.getIndexes().values()) {
            int c = 0;
            for (String fieldName : options.keySet()) {
                ColumnMeta col = meta.getColumnMetaByFieldName(fieldName);
                if (col == null) {
                    throw new RuntimeException("filed[" + fieldName + "] not found in entity meta[" + tableName + "]");
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
                log.warn("no index found when query " + tableName + " with options:" + sb.toString());
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

    /**
     * 更新 预编译
     *
     * @param tableName
     * @param meta
     * @return
     */
    public static String psUpdate(String tableName, TableMeta meta) {
        StringBuilder sb = new StringBuilder();
        sb.append("UPDATE `").append(tableName).append("` SET ");
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

    /**
     * 建表
     *
     * @param tableName
     * @param meta
     * @return
     */
    public static String createTable(String tableName, TableMeta meta) {
        StringBuilder sb = new StringBuilder();
        sb.append("CREATE TABLE IF NOT EXISTS `").append(tableName).append("`(\n");
        // columns
        for (ColumnMeta columnMeta : meta.getColumns()) {
            sb.append(columnMeta.buildCreateSQL()).append(",");
            sb.append("\n");
        }
        // pk
        List<ColumnMeta> ids = meta.getIds();
        if (ids != null && !ids.isEmpty()) {
            sb.append("PRIMARY KEY (");
            int idLength = ids.size();
            for (int i = 0; i < idLength; i++) {
                ColumnMeta columnMeta = ids.get(i);
                sb.append("`").append(columnMeta.getName()).append("`");
                if (i < idLength - 1) {
                    sb.append(",");
                }
            }
            sb.append(")");
        }

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

    /**
     * 插入 预编译
     *
     * @param tableName
     * @param meta
     * @return
     */
    public static String psInsert(String tableName, TableMeta meta) {
        StringBuilder sb = new StringBuilder();
        sb.append("INSERT INTO `");
        sb.append(tableName);
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

    /**
     * 构建表结构修改语句
     *
     * @param meta
     * @param orig
     * @return
     */
    public static List<String> updateTableStructure(TableMeta meta, TableMeta orig) {
        List<String> updates = new ArrayList<>();
        // 字段
        Set<String> allColumn = new HashSet<>();
        for (ColumnMeta columnMeta : meta.getColumns()) {
            allColumn.add(columnMeta.getName());
            ColumnMeta column = orig.getColumnMetaByColumnName(columnMeta.getName());
            // 新增
            if (column == null) {
                updates.add("ALTER TABLE `" + orig.getName() + "` ADD COLUMN " + columnMeta.buildCreateSQL());
            } else {
                // 列依然存在，但有变动
                if (!column.isSame(columnMeta)) {
                    // 列依然存在，但有变动
                    updates.add("ALTER TABLE `" + orig.getName() + "` MODIFY COLUMN " + columnMeta.buildCreateSQL());
                }
            }
        }
        // 可以删除字段，应当谨慎，线上环境建议屏蔽
        for (ColumnMeta columnMeta : orig.getColumns()) {
            if (!allColumn.contains(columnMeta.getName())) {
                updates.add("ALTER TABLE `" + orig.getName() + "` DROP COLUMN `" + columnMeta.getName() + "`");
            }
        }
        boolean resetId = false;
        // 主键
        List<ColumnMeta> clazzIds = meta.getIds();
        List<ColumnMeta> tableIds = orig.getIds();

        if (!Objects.deepEquals(clazzIds, tableIds)) {
            resetId = true;
        }
        if (resetId) {
            updates.add("ALTER TABLE `" + orig.getName() + "` DROP PRIMARY KEY ");
            String idStr = "";
            for (int i = 0; i < clazzIds.size(); i++) {
                ColumnMeta idColumnMeta = clazzIds.get(i);
                idStr += "`" + idColumnMeta.getName() + "`";
                if (i < clazzIds.size() - 1) {
                    idStr += ",";
                }
            }
            updates.add("ALTER TABLE `" + orig.getName() + "` ADD PRIMARY KEY (" + idStr + ")");
        }


        // 索引
        Set<String> mark = new HashSet<>();
        for (IndexMeta indexMeta : meta.getIndexes().values()) {
            mark.add(indexMeta.getName());
            IndexMeta index = orig.getIndexes().get(indexMeta.getName());
            if (index == null) {
                updates.add("ALTER TABLE `" + orig.getName() + "` ADD " + indexMeta.buildCreateSQL());
            } else {
                if (!index.isSame(indexMeta)) {
                    updates.add("DROP INDEX `" + indexMeta.getName() + "` on `" + meta.getName() + "`");
                    updates.add("ALTER TABLE `" + meta.getName() + "` ADD " + indexMeta.buildCreateSQL());
                }
            }
        }
        for (String indexName : orig.getIndexes().keySet()) {
            if (!mark.contains(indexName)) {
                updates.add("DROP INDEX `" + indexName + "` on `" + orig.getName() + "`");
            }
        }
        return updates;
    }

    /**
     * 构建getter
     *
     * @param tableName
     * @param meta
     * @return
     */
    public static String psGetter(String tableName, TableMeta meta) {
        String entryName = StringUtils.uncapitalize(meta.getClazz().getSimpleName());
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < meta.getColumns().size(); i++) {
            ColumnMeta col = meta.getColumns().get(i);
            sb.append(entryName);
            if (TypeEnum.TINYINT == col.getType() && (col.getField().getType() == Boolean.class || col.getField().getType() == boolean.class)) {
                sb.append(".is");
            } else {
                sb.append(".get");
            }
            sb.append(StringUtils.capitalize(col.getName())).append("()");
            if (i != meta.getColumns().size() - 1) {
                sb.append(",");
            }
            sb.append(System.getProperty("line.separator"));
        }
        return sb.substring(0, sb.length() - 2);
    }

    /**
     * 构建setter
     *
     * @param tableName
     * @param meta
     * @return
     */
    public static String psSetter(String tableName, TableMeta meta) {
        String entryName = StringUtils.uncapitalize(meta.getClazz().getSimpleName());
        StringBuilder sb = new StringBuilder();

        for (int i = 0; i < meta.getColumns().size(); i++) {
            ColumnMeta col = meta.getColumns().get(i);
            sb.append(entryName).append(".set")
                    .append(StringUtils.capitalize(col.getName())).append("(");
            switch (col.getType()) {
                case TINYINT:
                case SMALLINT:
                case INT:
                    sb.append("rs.getInt");
                    break;
                case BIGINT:
                    sb.append("rs.getLong");
                    break;
                case DOUBLE:
                    sb.append("rs.getDouble");
                    break;
                case CHAR:
                case VARCHAR:
                case TEXT:
                    sb.append("rs.getString");
                    break;
                case DATETIME:
                    sb.append("rs.getTimestamp");
                    break;
                case BLOB:
                case OBJ:
                    sb.append("rs.getBytes");
                    break;
                default:
                    sb.append("rs.get");
                    break;
            }
            sb.append("(\"").append(col.getName()).append("\"));");
            sb.append(System.getProperty("line.separator"));
        }
        return sb.substring(0, sb.length() - 2);
    }

}
