package com.ayjs.mxzg.common.persistence;

import com.ayjs.mxzg.common.convert.ConvertUtils;
import com.ayjs.mxzg.common.persistence.meta.TableMeta;
import com.ayjs.mxzg.common.persistence.repository.DataBaseAccessor;
import com.google.common.collect.Iterables;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.math.NumberUtils;

import java.sql.SQLException;
import java.util.Collection;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * 数据库操作辅助类
 */
@Slf4j
public class DatabaseHelper {
    /**
     * 查询当前区最大主键id like serverId%
     *
     * @param dataBaseAccessor
     * @param tableName
     * @param idName
     * @param serverId
     * @return
     */
    public static Long queryMaxId(DataBaseAccessor dataBaseAccessor, String tableName, String idName, int serverId) {
        String sql = SqlBuilder.selectMaxId(tableName, idName, serverId);
        return queryMaxId(sql, dataBaseAccessor, tableName);
    }

    /**
     * 查询当前区最大主键id
     *
     * @param dataBaseAccessor
     * @param tableName
     * @param idName
     * @return
     * @throws SQLException
     */
    public static Long queryMaxId(DataBaseAccessor dataBaseAccessor, String tableName, String idName) {
        String sql = SqlBuilder.selectMaxId(tableName, idName);
        return queryMaxId(sql, dataBaseAccessor, tableName);
    }

    private static Long queryMaxId(String sql, DataBaseAccessor dataBaseAccessor, String tableName) {
        try {
            List<Map<String, Object>> list = dataBaseAccessor.query(sql);
            Map<String, Object> result = Iterables.getFirst(list, null);
            Object value = result == null ? null : Iterables.getFirst(result.values(), null);
            return value == null ? null : ConvertUtils.toLong(value);
        } catch (SQLException e) {
            throw new RuntimeException(String.format("查询表{%s}最大主键id失败, sql: %s", tableName, sql), e);
        }
    }

    /**
     * 获取表名列表
     *
     * @param dataBaseAccessor
     * @param tableName
     * @return
     */
    public static List<String> getTableNames(DataBaseAccessor dataBaseAccessor, String tableName) {
        String sql = SqlBuilder.showTables(tableName);
        try {
            List<Map<String, Object>> list = dataBaseAccessor.query(sql);
            return list.stream()
                    .map(Map::values)
                    .flatMap(Collection::stream)
                    .map(ConvertUtils::toString)
                    .distinct()
                    .filter(name -> isSameTable(tableName, name))
                    .collect(Collectors.toList());
        } catch (SQLException e) {
            throw new RuntimeException(String.format("查看表失败, sql: %s", sql), e);
        }
    }

    /**
     * 是否是相同的表
     *
     * @param tableName
     * @param targetName
     * @return
     */
    public static boolean isSameTable(String tableName, String targetName) {
        if (targetName.equals(tableName)) {
            return true;
        }

        if (targetName.startsWith(tableName)) {
            int lastIndex = targetName.lastIndexOf("_");
            if (lastIndex != -1) {
                String shardingId = targetName.substring(lastIndex + 1);
                return NumberUtils.isParsable(shardingId);
            }
        }
        return false;
    }

    /**
     * 修改表结构
     *
     * @param dataBaseAccessor
     * @param meta
     * @param exitingTables
     */
    public static void updateTableStructure(DataBaseAccessor dataBaseAccessor, TableMeta meta, List<String> exitingTables) {
        List<String> updates = exitingTables.stream()
                .map(tableName -> buildUpdateTableStructureSQL(dataBaseAccessor, meta, tableName))
                .flatMap(List::stream)
                .collect(Collectors.toList());
        if (updates.isEmpty()) {
            return;
        }
        boolean allSuccess = true;
        for (String sql : updates) {
            log.info(String.format("修改表%s结构，修改语句为 %s", meta.getName(), sql));
            try {
                dataBaseAccessor.update(sql);
            } catch (Exception e) {
                allSuccess = false;
                log.error(String.format("修改表%s结构失败", meta.getName()), e);
            }
        }
        if (!allSuccess) {
            throw new RuntimeException(String.format("修改表%s结构失败", meta.getName()));
        }
    }

    /**
     * 构建表结构修改语句
     *
     * @param dataBaseAccessor
     * @param meta
     * @param tableName
     * @return
     */
    private static List<String> buildUpdateTableStructureSQL(DataBaseAccessor dataBaseAccessor, TableMeta meta, String tableName) {
        try {
            TableMeta orig = TableMeta.getTableFromDB(tableName, dataBaseAccessor);
            return SqlBuilder.updateTableStructure(meta, orig);
        } catch (Exception e) {
            throw new RuntimeException(String.format("build update table structure failed. TableName: %s", tableName), e);
        }
    }
}
