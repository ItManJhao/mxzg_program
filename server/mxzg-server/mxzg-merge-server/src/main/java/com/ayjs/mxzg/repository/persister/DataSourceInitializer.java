package com.ayjs.mxzg.repository.persister;

import com.alibaba.druid.pool.DruidDataSourceFactory;
import com.ayjs.mxzg.common.persistence.repository.DataBaseAccessor;
import com.ayjs.mxzg.common.persistence.repository.DataBaseAccessorManager;
import com.ayjs.mxzg.common.util.gson.GsonUtils;
import com.ayjs.mxzg.config.Config;
import com.ayjs.mxzg.repository.manager.MergeRepositoryManager;
import com.ayjs.mxzg.repository.platform.DatabaseInfo;
import com.ayjs.mxzg.repository.platform.Server;
import lombok.extern.slf4j.Slf4j;

import javax.sql.DataSource;
import java.util.Map;
import java.util.Properties;

/**
 * @Author: CWJ
 * @Date: 2020/8/19
 **/
@Slf4j
public class DataSourceInitializer {
    public static void initPlatform() {
        try {
            Properties dbTemplate = Config.getInstance().getDbTemplate();
            if (!Config.getInstance().isStartWithFile()) {
                dbTemplate.replace("url", Config.getInstance().getJdbcUrl());
                dbTemplate.replace("username", Config.getInstance().getPlatformUser());
                dbTemplate.replace("password", Config.getInstance().getPlatformPwd());
            }
            DataSource gameDataSource = initDataSource(dbTemplate);
            DataBaseAccessorManager dataBaseAccessorManager = DataBaseAccessorManager.getInstance();
            dataBaseAccessorManager.add(new DataBaseAccessor("platform", gameDataSource,
                    Runtime.getRuntime().availableProcessors() * 2, 1000));
        } catch (Exception e) {
            log.error("platform config path:", e);
            throw new RuntimeException(e);
        }
    }

    public static DataSource initDataSource(Properties properties) {
        DataSource dataSource = null;
        try {
            dataSource = DruidDataSourceFactory.createDataSource(properties);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return dataSource;
    }

    public static void initDBSource(Server server, Map<String, DatabaseInfo> databaseInfo) {
        initGameSource(server, databaseInfo);
        initLogSource(server, databaseInfo);
    }

    private static void initGameSource(Server server, Map<String, DatabaseInfo> databaseInfoMap) {
        DataBaseAccessorManager dataBaseAccessorManager = DataBaseAccessorManager.getInstance();

        Properties dbTemplate = Config.getInstance().getDbTemplate();

        Properties properties = new Properties();
        properties.putAll(dbTemplate);

        String url = String.valueOf(properties.get("url"));

        String[] split = url.split("//");
        String[] split1 = split[1].split("\\?");

        DatabaseInfo databaseInfo = databaseInfoMap.get(server.getDbHost());


        if (databaseInfo != null) {
            properties.replace("username", databaseInfo.getMasterDbUser());
            properties.replace("password", databaseInfo.getMasterDbPassword());
            url = url.replace(split1[0], databaseInfo.getMasterDb() + ":" + server.getDbPort() + "/" + server.getDbGameDatabase());
        } else {
            properties.replace("username", server.getDbUser());
            properties.replace("password", server.getDbPassword());
            url = url.replace(split1[0], server.getDbHost() + ":" + server.getDbPort() + "/" + server.getDbGameDatabase());
        }

        properties.replace("url", url);
        log.info("数据库信息:{},{},{}", GsonUtils.toJson(databaseInfoMap), server.getDbHost(), GsonUtils.toJson(databaseInfo));
        log.info("serverId:" + server.getId() + ",url:" + properties.get("url"));

        dataBaseAccessorManager.add(new DataBaseAccessor(MergeRepositoryManager.getInstance().buildSign(server.getId(), MergeRepositoryManager.DATA_SIGN),
                initDataSource(properties), Runtime.getRuntime().availableProcessors() * 2, 1000));
    }

    private static void initLogSource(Server server, Map<String, DatabaseInfo> databaseInfoMap) {
        DataBaseAccessorManager dataBaseAccessorManager = DataBaseAccessorManager.getInstance();

        Properties dbTemplate = Config.getInstance().getDbTemplate();

        Properties properties = new Properties();
        properties.putAll(dbTemplate);
        String url = String.valueOf(properties.get("url"));
        String[] split = url.split("//");
        String[] split1 = split[1].split("\\?");

        DatabaseInfo databaseInfo = databaseInfoMap.get(server.getDbHost());

        if (databaseInfo != null) {
            properties.replace("username", databaseInfo.getMasterDbUser());
            properties.replace("password", databaseInfo.getMasterDbPassword());
            url = url.replace(split1[0], databaseInfo.getMasterDb() + ":" + server.getDbPort() + "/" + server.getDbLogDatabase());
        } else {
            properties.replace("username", server.getDbUser());
            properties.replace("password", server.getDbPassword());
            url = url.replace(split1[0], server.getDbHost() + ":" + server.getDbPort() + "/" + server.getDbLogDatabase());
        }
        properties.replace("url", url);

        log.info("数据库信息:{},{},{}", GsonUtils.toJson(databaseInfoMap), server.getDbHost(), GsonUtils.toJson(databaseInfo));
        log.info("serverId:" + server.getId() + ",url:" + properties.get("url"));

        dataBaseAccessorManager.add(new DataBaseAccessor(MergeRepositoryManager.getInstance().buildSign(server.getId(), MergeRepositoryManager.LOG_SIGN),
                initDataSource(properties), Runtime.getRuntime().availableProcessors() * 2, 1000));
    }
}
