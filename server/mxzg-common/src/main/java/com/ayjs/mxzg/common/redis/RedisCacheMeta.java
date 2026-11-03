package com.ayjs.mxzg.common.redis;


import com.ayjs.mxzg.common.persistence.meta.CacheMeta;
import com.ayjs.mxzg.common.persistence.meta.ColumnMeta;

import java.util.Iterator;
import java.util.List;

/**
 * redis cacheMete
 */
class RedisCacheMeta extends CacheMeta {

    private final String name;

    RedisCacheMeta(List<ColumnMeta> columns) {
        StringBuilder sb = new StringBuilder();
        Iterator<ColumnMeta> it = columns.iterator();
        while (it.hasNext()) {
            ColumnMeta meta = it.next();
            super.add(meta);
            sb.append(meta.getName());
            if (it.hasNext()) {
                sb.append("_");
            }
        }
        this.name = sb.toString();
    }

    String getName() {
        return name;
    }
}
