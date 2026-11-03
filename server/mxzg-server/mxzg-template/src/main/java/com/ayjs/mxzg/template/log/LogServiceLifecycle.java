package com.ayjs.mxzg.template.log;

import com.ayjs.mxzg.common.executor.OrderlyExecutor;
import com.ayjs.mxzg.common.executor.OrderlyExecutorService;
import com.ayjs.mxzg.common.lifecycle.Lifecycle;
import com.ayjs.mxzg.common.lifecycle.LifecycleInfo;
import com.ayjs.mxzg.common.lifecycle.Ordinal;
import com.ayjs.mxzg.common.lifecycle.Priority;
import com.ayjs.mxzg.common.persistence.log.ILog;
import com.ayjs.mxzg.common.persistence.log.LogRepositoryRegistry;
import com.ayjs.mxzg.common.persistence.log.buffer.Buffers;
import com.ayjs.mxzg.common.persistence.log.buffer.DelayedLogBufferExecutor;
import com.ayjs.mxzg.common.persistence.log.buffer.LogBuffer;
import com.google.common.base.Preconditions;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.TimeUnit;

/**
 * 日志服务
 */
@SuppressWarnings("rawtypes")
@Slf4j
@Service
public class LogServiceLifecycle implements Lifecycle {

    /**
     * 日志缓冲
     */
    private final Map<Class<?>, List<LogBuffer>> bufferMap = new HashMap<>();

    /**
     * 日志输出到数据库
     */
    @Value("${log.to.db:true}")
    private boolean logToDB;
    /**
     * 日志输出到数据库
     */
    @Value("${log.to.file:false}")
    private boolean logToFile;
    /**
     * 延时日志缓冲最大数量
     */
    @Value("${delayed.log.buffer.max.size:1000}")
    private int delayedLogBufferMaxSize;
    /**
     * 延时日志缓冲清空间隔 单位:毫秒
     */
    @Value("${delayed.log.buffer.flush.period:30000}")
    private int delayedLogBufferFlushPeriod;
    /**
     * 延时日志持久化批量处理数量
     */
    @Value("${delayed.log.persistence.batch.add.size:200}")
    private int delayedLogPersistenceBatchAddSize;
    /**
     * 日志持久化线程数量
     */
    @Value("${log.persistence.threads:2}")
    private int logPersistenceThreads;
    /**
     * 日志输出到文件目录
     */
    @Value("${log.to.file.dir:game_log}")
    private String logToFileDir;
    @Autowired
    LogRepositoryRegistry logRepositoryRegistry;

    private OrderlyExecutorService orderlyExecutorService;

    private DelayedLogBufferExecutor delayedLogBufferExecutor;

    private void initialize() {
        log.info("LOG TO DB --- {}", logToDB);
        if (logToDB) {
            Preconditions.checkArgument(delayedLogBufferMaxSize > 0, "buffer max size{%s} cannot be negative", delayedLogBufferMaxSize);
            Preconditions.checkArgument(delayedLogBufferFlushPeriod > 0, "buffer flush period{%s} cannot be negative", delayedLogBufferFlushPeriod);
            Preconditions.checkArgument(delayedLogPersistenceBatchAddSize > 0, "batch add size{%s} cannot be negative", delayedLogPersistenceBatchAddSize);
            Preconditions.checkArgument(logPersistenceThreads > 0, "log persistence threads{%s} cannot be negative", logPersistenceThreads);

            orderlyExecutorService = new OrderlyExecutor("LOG PERSISTENCE EXECUTOR", logPersistenceThreads);

            delayedLogBufferExecutor = DelayedLogBufferExecutor.INSTANCE;

            initializeLogToDB(delayedLogBufferMaxSize,
                    delayedLogBufferFlushPeriod,
                    delayedLogPersistenceBatchAddSize,
                    logRepositoryRegistry,
                    orderlyExecutorService);
        }


        // 暂时没有文件记录日志
//        if (logToFile) {
//            initializeLogToFile(delayedLogBufferMaxSize,
//                    delayedLogBufferFlushPeriod,
//                    delayedLogPersistenceBatchAddSize,
//                    logRepositoryRegistry,
//                    orderlyExecutorService,
//                    logToFileDir);
//        }
    }

    private void initializeLogToDB(int delayedLogBufferMaxSize,
                                   int delayedLogBufferFlushPeriod,
                                   int delayedLogPersistenceBatchAddSize,
                                   LogRepositoryRegistry registry,
                                   OrderlyExecutorService orderlyExecutorService) {
        registry.getRepositories().forEach((clazz, repository) ->
                register(clazz, Buffers.newDelayedLogBuffer(
                        new JDBCLogPersistence<>(repository),
                        orderlyExecutorService,
                        delayedLogBufferMaxSize,
                        delayedLogBufferFlushPeriod,
                        delayedLogPersistenceBatchAddSize)));
    }

//    private void initializeLogToFile(int delayedLogBufferMaxSize,
//                                     int delayedLogBufferFlushPeriod,
//                                     int delayedLogPersistenceBatchAddSize,
//                                     LogRepositoryRegistry registry,
//                                     OrderlyExecutorService orderlyExecutorService,
//                                     String logToFileDir) {
//        String dirname = StringUtils.isBlank(logToFileDir) ? Log4jPersistence.DEFAULT_DIR : logToFileDir;
//        log.info("log to file dir's absolute path: {}", dirname);
//
//        Set<String> registeredFilename = new HashSet<>();
//        registry.getRepositories().forEach((clazz, repository) -> {
//            String filename = metaDataRegistry.getMetaData(clazz).getTableMeta().getName();
//            if (registeredFilename.add(filename)) {
//                register(clazz, Buffers.newDelayedLogBuffer(
//                        new Log4jPersistence<>(dirname, filename),
//                        orderlyExecutorService,
//                        delayedLogBufferMaxSize,
//                        delayedLogBufferFlushPeriod,
//                        delayedLogPersistenceBatchAddSize));
//            } else {
//                throw new RuntimeException(String.format("[%s] filename[%s] is duplicated", clazz.getName(), filename));
//            }
//        });
//    }

    private void register(Class<?> clazz, LogBuffer buffer) {
        bufferMap.computeIfAbsent(clazz, key -> new ArrayList<>(0)).add(buffer);
    }

    @Override
    public LifecycleInfo getInfo() {
        return LifecycleInfo.valueOf(Priority.SYSTEM, Ordinal._5, "LOG");
    }

    public <T extends ILog> List<LogBuffer> getBuffers(T entity) {
        return bufferMap.get(entity.getClass());
    }

    @Override
    public void start() throws Exception {
        initialize();
    }

    @Override
    public void stop() throws Exception {
        bufferMap.values().stream().flatMap(List::stream).forEach(LogBuffer::flush);
        if (delayedLogBufferExecutor != null) {
            delayedLogBufferExecutor.shutdown();
            log.info("DelayedLogBufferExecutor closed");
        }
        if (orderlyExecutorService != null) {
            orderlyExecutorService.shutdown();
            int count = 0;
            while (!orderlyExecutorService.awaitTermination(5, TimeUnit.SECONDS)) {
                log.info("OrderlyExecutorService await termination {}", ++count);
            }
            log.info("OrderlyExecutorService closed");
        }
    }
}
