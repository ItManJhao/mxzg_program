package com.ayjs.mxzg.common.persistence.persister;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.meta.ColumnMeta;
import com.ayjs.mxzg.common.persistence.meta.MetaData;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * 数据操作辅助
 */
public class PersisterSupport {
    static <T> List<T> parse(MetaData metaData, List<Map<String, Object>> rs) throws SQLException {
        List<T> list = new ArrayList<>();
        try {
            for (Map<String, Object> map : rs) {
                @SuppressWarnings("unchecked")
                T t = (T) metaData.getEntityType().newInstance();
                for (ColumnMeta col : metaData.getTableMeta().getColumns()) {
                    if (map.containsKey(col.getName())) {
                        col.cast((AbstractEntity) t, map.get(col.getName()));
                    }
                }
                list.add(t);
            }
        } catch (Exception e) {
            throw new SQLException("build entity from result set failed", e);
        }
        return list;
    }
}
