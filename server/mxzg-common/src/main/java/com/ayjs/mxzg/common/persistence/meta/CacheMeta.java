package com.ayjs.mxzg.common.persistence.meta;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * 缓存
 */
public class CacheMeta {
    private final List<ColumnMeta> columns = new ArrayList<>();

    protected void add(ColumnMeta column) {
        columns.add(column);
    }

    public List<ColumnMeta> getColumns() {
        return columns;
    }

    public boolean match(Map<String, Object> options) {
        if (columns.size() != options.size())
            return false;
        for (ColumnMeta columnMeta : columns) {
            if (!options.containsKey(columnMeta.getField().getName()))
                return false;
        }
        return true;
    }
}
