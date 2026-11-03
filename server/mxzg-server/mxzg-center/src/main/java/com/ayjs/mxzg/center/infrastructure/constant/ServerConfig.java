package com.ayjs.mxzg.center.infrastructure.constant;

import lombok.Getter;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;

@Getter
@Configuration
public class ServerConfig {
    @Value("${server.debug:true}")
    private boolean serverDebug;
    @Value("${server.id}")
    private int serverId;
    @Value("${gm.cmd.open:false}")
    private boolean gmCmdOpen;
    @Value("${server.lang:1}")
    private int serverLang;

    @Value("${scheduler.threads:2}")
    private int schedulerThreads;

    @Value("${scheduler.threshold:200}")
    private int schedulerThreshold;
    /**
     * tcp socket绑定的端口
     */
    @Value("${network.tcpSocket.port:8801}")
    private int networkTcpSocketPort;
    /**
     * netty的io线程数
     */
    @Value("${network.tcpSocket.threads:10}")
    private int networkTcpSocketThreads;
    /**
     * netty的空闲检测时间秒
     */
    @Value("${network.tcpSocket.idle:40}")
    private int networkTcpSocketIdle;

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
