package com.ayjs.mxzg.gameserver.infrastructure.constant;

import com.ayjs.mxzg.common.util.GJsonUtils;
import com.ayjs.mxzg.common.util.StringUtil;
import com.google.common.reflect.TypeToken;
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

    @Value("${sub.server.id:}")
    private String subServerId;

    @Value("${gm.cmd.open:false}")
    private boolean gmCmdOpen;
    @Value("${server.lang:1}")
    private int serverLang;
    @Value("${sensitive.server.lang:}")
    private int[] sensitiveLang;
    @Value("${server.platformId:1}")
    private int serverPlatformId;
    @Value("${server.platformSonId:10001}")
    private int serverPlatformSonId;

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
     * web socket绑定端口
     */
    @Value("${network.webSocket.port:0}")
    private int networkWebSocketPort;

    @Value("${network.webSocket.sslFile:}")
    private String sslFile;
    @Value("${network.webSocket.sslPassword:}")
    private String sslPassword;

    /**
     * netty的io线程数
     */
    @Value("${network.tcpSocket.threads:10}")
    private int networkTcpSocketThreads;
    /**
     * web socket的io线程数
     */
    @Value("${network.webSocket.threads:10}")
    private int networkWebSocketThreads;
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
    /**
     * 平台地址
     */
    @Value("${platform.uri}")
    private String platformUri;
    /**
     * 平台的通信key
     */
    @Value("${platform.key}")
    private String platformKey;
    /**
     * ip解析数据文件
     */
    @Value("${ip2region.file:ip2region.db}")
    private String ip2regionFile;
    /**
     * 同省频道是否开启
     */
    @Value("${game.chat.provincial.channel:false}")
    private boolean gameChatProvincialChannel;

    @Value("${server.platformId}")
    private int platformId;

    @Value("${management.url:http}")
    private String managementUrl;

    @Value("${external.chat.switch:false}")
    private boolean externalChatSwitch;

    private Integer[] subServerIds;

    public boolean matchServerId(int serverId) {
        for (int subServerId : getSubServerIds()) {
            if (serverId == subServerId) {
                return true;
            }
        }
        return false;
    }

    public Integer[] getSubServerIds() {
        if (subServerIds == null) {
            if (StringUtil.isBlank(subServerId)) {
                subServerIds = new Integer[]{serverId};
            } else {
                subServerIds = GJsonUtils.fromJson(subServerId, new TypeToken<Integer[]>() {
                });
            }
        }
        return subServerIds;
    }
}
