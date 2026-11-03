package com.ayjs.mxzg.common.persistence.repository;

import lombok.extern.slf4j.Slf4j;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

/**
 * 数据库仓库管理
 */
@Slf4j
public class DataBaseAccessorManager {

    static class DataBaseAccessorManagerHolder {
        static DataBaseAccessorManager instance = new DataBaseAccessorManager();
    }

    /*
     * 所有的db对象
     */
    private Map<String, DataBaseAccessor> databases = new ConcurrentHashMap<>();

    private DataBaseAccessorManager() {
    }

    public static DataBaseAccessorManager getInstance() {
        return DataBaseAccessorManagerHolder.instance;
    }

    /**
     * 将数据库添加到管理中
     *
     * @param dataBaseAccessor 数据库
     */
    public void add(DataBaseAccessor dataBaseAccessor) {
        DataBaseAccessor old = databases.putIfAbsent(dataBaseAccessor.getName(), dataBaseAccessor);
        log.debug("database manager add:{}, datasource:{}", dataBaseAccessor.getName(), dataBaseAccessor.getDataSource());
        if (old != null && old != dataBaseAccessor)
            log.error("database " + dataBaseAccessor.getName() + " already exist in manager");
    }

    /**
     * 将数据库从管理中移除
     *
     * @param dataBaseAccessor 数据库
     */
    public void remove(DataBaseAccessor dataBaseAccessor) {
        if (!databases.remove(dataBaseAccessor.getName(), dataBaseAccessor))
            log.error("database " + dataBaseAccessor.getName() + " not found in manager");
    }

    /**
     * 移除管理中指定的数据库
     *
     * @param dbName 数据库的名字
     */
    public void remove(String dbName) {
        if (databases.remove(dbName) == null)
            log.error("database " + dbName + " not found in manager");
    }

    /**
     * 清空
     */
    public void clear() {
        databases.clear();
    }

    /**
     * 通过名字获取一个数据库
     *
     * @param dbName 数据库名字
     * @return 数据库
     */
    public DataBaseAccessor get(String dbName) {
        return databases.get(dbName);
    }

    protected List<Runnable> hook = new ArrayList<>();

    private boolean stopped = false;

    protected void addHook(Runnable task) {
        hook.add(task);
    }

    /**
     * 关闭
     */
    public synchronized void shutdown() {
        if (stopped) {
            return;
        }
        stopped = true;
        databases.forEach((k, v) -> v.shutdown());
        if (hook.size() == 0)
            return;
        hook.forEach(n -> {
            try {
                n.run();
            } catch (Throwable t) {
                log.error("shutdown error", t);
            }
        });
    }
}
