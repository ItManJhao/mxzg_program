package com.ayjs.mxzg.cross.infrastructure.persistence;

import com.alibaba.druid.pool.DruidDataSourceFactory;
import com.ayjs.mxzg.common.base.PropertiesLoader;
import com.ayjs.mxzg.common.convert.ConvertUtils;
import com.ayjs.mxzg.common.persistence.repository.DataBaseAccessor;
import com.ayjs.mxzg.common.persistence.repository.DataBaseAccessorManager;
import org.springframework.context.ApplicationContextInitializer;
import org.springframework.context.ConfigurableApplicationContext;
import org.springframework.core.env.ConfigurableEnvironment;
import org.springframework.lang.NonNull;

import javax.sql.DataSource;
import java.util.Objects;
import java.util.Properties;

public class DataSourceInitializer implements ApplicationContextInitializer<ConfigurableApplicationContext> {

    @Override
    public void initialize(@NonNull ConfigurableApplicationContext configurableApplicationContext) {
        try {
            ConfigurableEnvironment environment = configurableApplicationContext.getEnvironment();
            String gameDataSourceProperties = ConvertUtils.toString(environment.getProperty("database.game.file"));
            if (Objects.isNull(gameDataSourceProperties)) {
                gameDataSourceProperties = "classpath:database-game.properties";
            }

            String logDataSourceProperties = ConvertUtils.toString(environment.getProperty("database.log.file"));
            if (Objects.isNull(logDataSourceProperties)) {
                logDataSourceProperties = "classpath:database-log.properties";
            }

            int slowLog = ConvertUtils.toInt(environment.getProperty("database.slowLog"));
            if (slowLog <= 0) {
                slowLog = 200;
            }
            int gameSaveThreads = ConvertUtils.toInt(environment.getProperty("database.game.saveThreads"));
            if (gameSaveThreads <= 0) {
                gameSaveThreads = 2;
            }
            int logSaveThreads = ConvertUtils.toInt(environment.getProperty("database.log.saveThreads"));
            if (logSaveThreads <= 0) {
                logSaveThreads = 1;
            }
            DataSource gameDataSource = initDataSource(gameDataSourceProperties);
            DataSource logDataSource = initDataSource(logDataSourceProperties);

            DataBaseAccessorManager dataBaseAccessorManager = DataBaseAccessorManager.getInstance();
            dataBaseAccessorManager.add(new DataBaseAccessor("data", gameDataSource, gameSaveThreads, slowLog));
            dataBaseAccessorManager.add(new DataBaseAccessor("log", logDataSource, logSaveThreads, slowLog));
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }

    public DataSource initDataSource(String dataSourceProperties) {
        DataSource dataSource = null;
        try {
            Properties properties = PropertiesLoader.loadProperties(dataSourceProperties);

            dataSource = DruidDataSourceFactory.createDataSource(properties);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return dataSource;
    }
}
