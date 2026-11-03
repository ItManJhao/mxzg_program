package com.ayjs.mxzg.repository.manager;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.meta.TableMeta;
import com.ayjs.mxzg.repository.platform.DatabaseInfo;
import com.ayjs.mxzg.repository.platform.Server;
import com.google.common.collect.Maps;

import java.util.Map;
import java.util.Set;

/**
 * 表结构体管理
 *
 * @Author: CWJ
 * @Date: 2020/8/20
 **/
public class TableMetaManager {

    private static TableMetaManager instance;

    public static TableMetaManager getInstance() {
        if (instance == null) {
            instance = new TableMetaManager();
        }
        return instance;
    }

    protected Map<Class<? extends AbstractEntity>, TableMeta> metaMap;
    protected Map<String, TableMeta> tableNameMap;

    public void init(Map<String, Set<Class<? extends AbstractEntity>>> tables) {
        metaMap = Maps.newHashMap();
        tableNameMap = Maps.newHashMap();
        tables.values().forEach(entities -> {
            entities.forEach(this::addTableMeta);
        });

        addTableMeta(Server.class);
        addTableMeta(DatabaseInfo.class);
    }

    public void addTableMeta(Class<? extends AbstractEntity> clz) {
        TableMeta tableMeta = TableMeta.parse(clz);
        metaMap.put(clz, tableMeta);
        tableNameMap.put(tableMeta.getName(), tableMeta);
    }

    public TableMeta get(Class<? extends AbstractEntity> clz) {
        return metaMap.get(clz);
    }

    public TableMeta getByTableName(String tableName) {
        return tableNameMap.get(tableName);
    }

    public Map<Class<? extends AbstractEntity>, TableMeta> getMetaMap() {
        return metaMap;
    }
}
