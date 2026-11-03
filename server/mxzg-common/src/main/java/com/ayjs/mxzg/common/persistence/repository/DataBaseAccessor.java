package com.ayjs.mxzg.common.persistence.repository;

import com.ayjs.mxzg.common.util.NamesThreadFactory;
import lombok.extern.slf4j.Slf4j;

import javax.sql.DataSource;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.ScheduledThreadPoolExecutor;
import java.util.concurrent.TimeUnit;

/**
 * 数据库存取器
 */
@Slf4j
public class DataBaseAccessor {

    /*
     * 数据库连接池
     */
    private final DataSource dataSource;

    /*
     * 缓慢查询
     */
    private int slowLog = 100;

    /*
     * 名字
     */
    private final String name;

    /*
     * 持久化的线程池
     */
    private ScheduledThreadPoolExecutor[] pools;

    /**
     * 使用配置文件构造
     */
    public DataBaseAccessor(String name, DataSource dataSource, int saveThreads, int slowLog) {
        this.name = name;
        this.dataSource = dataSource;
        this.slowLog = slowLog;
        NamesThreadFactory namedThreadFactory = new NamesThreadFactory("db-saver");
        int threads = saveThreads;
        pools = new ScheduledThreadPoolExecutor[threads];
        for (int i = 0; i < threads; i++) {
            pools[i] = new ScheduledThreadPoolExecutor(1, namedThreadFactory);
        }
    }

    public String getName() {
        return name;
    }

    public int getSlowLog() {
        return slowLog;
    }

    private int pool_index = 0;

    protected ScheduledExecutorService getPool() {
        if (pools == null) {
            return null;
        }
        if (++pool_index >= pools.length) {
            pool_index = 0;
        }
        return pools[pool_index];
    }

    /**
     * 从连接池中获取一条连接
     *
     * @return 连接
     * @throws SQLException 参考{@link DataSource#getConnection()}
     */
    public Connection getConnection() throws SQLException {
        return dataSource.getConnection();
    }

    /**
     * 获取连接源
     *
     * @return
     */
    public DataSource getDataSource() {
        return dataSource;
    }

    /**
     * 执行更新操作，操作结果参考{@link Statement#executeUpdate(String)}
     *
     * @param sql 更新语句
     * @return 更新语句影响的记录条数
     * @throws SQLException 数据库异常
     */
    public int update(String sql) throws SQLException {
        if (log.isDebugEnabled()) {
            log.debug(sql);
        }
        Connection connection = null;
        Statement statement = null;
        long t = System.currentTimeMillis();
        try {
            connection = dataSource.getConnection();
            statement = connection.createStatement();
            return statement.executeUpdate(sql);
        } finally {
            if (statement != null) {
                try {
                    statement.close();
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

    /**
     * 批量执行sql
     *
     * @param sql
     * @return
     * @throws Exception
     */
    public int[] batch(List<String> sql) throws Exception {
        Connection connection = null;
        Statement statement = null;
        long t = System.currentTimeMillis();
        try {
            connection = dataSource.getConnection();
            statement = connection.createStatement();
            for (String s : sql)
                statement.addBatch(s);
            return statement.executeBatch();
        } finally {
            if (statement != null) {
                try {
                    statement.close();
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

    /**
     * 执行查询操作
     *
     * @param sql 查询语句
     * @return 查询的结果
     * @throws SQLException 执行数据库操作时的异常
     */
    public List<Map<String, Object>> query(String sql) throws SQLException {
        if (log.isDebugEnabled()) {
            log.debug(sql);
        }
        Connection connection = null;
        Statement statement = null;
        ResultSet rs = null;
        long t = System.currentTimeMillis();
        try {
            connection = dataSource.getConnection();
            statement = connection.createStatement();
            rs = statement.executeQuery(sql);
            List<Map<String, Object>> list = new ArrayList<>();
            ResultSetMetaData meta = rs.getMetaData();
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                for (int i = 0; i < meta.getColumnCount(); i++) {
                    String name = meta.getColumnLabel(i + 1);
                    Object value = rs.getObject(name);
                    map.put(name, value);
                }
                list.add(map);
            }
            return list;
        } finally {
            if (rs != null) {
                try {
                    rs.close();
                } catch (SQLException e) {
                    log.error("close result failed", e);
                }
            }
            if (statement != null) {
                try {
                    statement.close();
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

    public void shutdown() {
        if (pools == null) {
            return;
        }
        for (ScheduledThreadPoolExecutor pool : pools) {
            try {
                pool.shutdown();
                while (!pool.isTerminated()) {
                    if (log.isWarnEnabled()) {
                        log.warn(pool.getQueue().size() + " task(s) in save queue.");
                    }
                    try {
                        pool.awaitTermination(1, TimeUnit.SECONDS);
                    } catch (InterruptedException e) {
                    }
                }
            } catch (Throwable t) {
                log.error("shutdown error", t);
            }
        }
    }
}
