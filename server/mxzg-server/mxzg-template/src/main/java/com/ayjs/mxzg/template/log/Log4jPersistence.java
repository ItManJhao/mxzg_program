package com.ayjs.mxzg.template.log;

import com.ayjs.mxzg.common.persistence.log.ILog;
import com.ayjs.mxzg.common.persistence.log.LogPersistence;
import com.ayjs.mxzg.common.util.gson.GsonUtils;
import com.google.common.base.Preconditions;
import org.apache.commons.lang3.StringUtils;
import org.apache.logging.log4j.Level;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.apache.logging.log4j.core.Appender;
import org.apache.logging.log4j.core.Filter;
import org.apache.logging.log4j.core.LoggerContext;
import org.apache.logging.log4j.core.appender.RollingRandomAccessFileAppender;
import org.apache.logging.log4j.core.appender.rolling.DefaultRolloverStrategy;
import org.apache.logging.log4j.core.appender.rolling.SizeBasedTriggeringPolicy;
import org.apache.logging.log4j.core.appender.rolling.TimeBasedTriggeringPolicy;
import org.apache.logging.log4j.core.config.AppenderRef;
import org.apache.logging.log4j.core.config.Configuration;
import org.apache.logging.log4j.core.config.LoggerConfig;
import org.apache.logging.log4j.core.filter.ThresholdFilter;
import org.apache.logging.log4j.core.layout.PatternLayout;

import java.util.List;

/**
 * log日志文件持久化
 */
public class Log4jPersistence<T extends ILog> implements LogPersistence<T> {

    public static final String DEFAULT_DIR = "gamelog";
    private static final String SEPARATE = "/";

    private final Logger logger;

    public Log4jPersistence(String dirname, String filename) {
        Preconditions.checkArgument(StringUtils.isNotBlank(dirname), "dirname{%s} is blank", dirname);
        Preconditions.checkArgument(StringUtils.isNotBlank(filename), "filename{%s} is blank", filename);
        logger = buildLogger(dirname, filename);
    }

    private Logger buildLogger(String dirname, String filename) {
        final LoggerContext ctx = (LoggerContext) LogManager.getContext(false);
        final Configuration config = ctx.getConfiguration();

        final String fullFilename = dirname + SEPARATE + filename;
        final String appenderName = filename.toUpperCase() + " APPENDER";

        Appender appender = RollingRandomAccessFileAppender.newBuilder()
                .withName(appenderName)
                .withFileName(fullFilename)
                .withFilePattern(fullFilename + "-%d{yyyy-MM-dd}-%i.gz")
                .withFilter(ThresholdFilter.createFilter(Level.INFO, Filter.Result.ACCEPT, Filter.Result.DENY))
                .withLayout(PatternLayout.newBuilder().withPattern(PatternLayout.DEFAULT_CONVERSION_PATTERN).build())
                .withPolicy(TimeBasedTriggeringPolicy.newBuilder().build())
                .withPolicy(SizeBasedTriggeringPolicy.createPolicy("300 MB"))
                .withStrategy(DefaultRolloverStrategy.newBuilder().withMax("9999").withConfig(config).build())
                .build();
        appender.start();
        config.addAppender(appender);

        AppenderRef ref = AppenderRef.createAppenderRef(appenderName, null, null);

        LoggerConfig loggerConfig = LoggerConfig.createLogger(
                false,
                Level.INFO,
                filename,
                "true",
                new AppenderRef[]{ref},
                null, config,
                null);

        loggerConfig.addAppender(appender, null, null);

        config.addLogger(filename, loggerConfig);
        ctx.updateLoggers();

        return LogManager.getLogger(filename);
    }

    @Override
    public void add(T entity) {
        logger.info(GsonUtils.toJson(entity));
    }

    @Override
    public void batchAdd(List<T> entities) {
        entities.forEach(this::add);
    }

    @Override
    public String toString() {
        return "Log4jPersistence{" +
                "name=" + logger.getName() +
                '}';
    }
}
