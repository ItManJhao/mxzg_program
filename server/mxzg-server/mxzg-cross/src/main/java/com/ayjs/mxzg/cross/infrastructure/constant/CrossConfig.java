package com.ayjs.mxzg.cross.infrastructure.constant;

import lombok.Getter;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;

@Getter
@Configuration
public class CrossConfig {
	
    @Value("${config.path}")
    private String configPath;

    /**
     * 日志输出到数据库
     */
    @Value("${log.to.db:true}")
    private boolean logToDB;
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
     * 日志输出到文件
     */
    @Value("${log.to.file:false}")
    private boolean logToFile;
    /**
     * 日志输出到文件目录
     */
    @Value("${log.to.file.dir:game_log}")
    private String logToFileDir;
}
