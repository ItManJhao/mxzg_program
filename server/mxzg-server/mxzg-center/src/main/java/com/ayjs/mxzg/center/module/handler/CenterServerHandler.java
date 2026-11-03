package com.ayjs.mxzg.center.module.handler;

import com.ayjs.mxzg.center.module.CenterServerWorker;
import com.ayjs.mxzg.center.module.SessionManager;
import com.ayjs.mxzg.center.module.dao.CrossClusterDao;
import com.ayjs.mxzg.center.module.dao.CrossConfigDao;
import com.ayjs.mxzg.center.module.dao.ServerInfoDao;
import com.ayjs.mxzg.center.module.domain.CrossCluster;
import com.ayjs.mxzg.center.module.domain.CrossConfig;
import com.ayjs.mxzg.center.module.domain.ServerInfo;
import com.ayjs.mxzg.common.util.time.LocalDateTimeUtil;
import com.ayjs.mxzg.config.excel.cache.SystemSysCache;
import com.ayjs.mxzg.message.center.PushServerCrossInfoMessage;
import com.ayjs.mxzg.message.center.ReportServerInfoMessage;
import com.ayjs.mxzg.message.center.RequestCrossGroupMessage;
import com.ayjs.mxzg.message.center.RequestCrossServerInfoMessage;
import com.ayjs.mxzg.message.center.dto.CrossGroup;
import com.ayjs.mxzg.message.center.dto.GroupType;
import com.ayjs.mxzg.message.cross.CrossRegroupMessage;
import com.ayjs.rpc.annotation.RemoteMethod;
import com.ayjs.rpc.dispatcher.MessageHandler;
import com.ayjs.rpc.server.Connection;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.time.LocalDate;
import java.util.List;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;
import java.util.stream.Collectors;

/**
 * 中心服消息处理器
 */
@Slf4j
@Component
public class CenterServerHandler implements MessageHandler {

    @Autowired
    private ServerInfoDao serverInfoDao;
    @Autowired
    private CrossConfigDao crossConfigDao;
    @Autowired
    private CrossClusterDao crossClusterDao;
    @Autowired
    private SessionManager sessionManager;
    @Autowired
    private SystemSysCache systemSysCache;
    @Autowired
    private CenterServerWorker centerServerWorker;

    /** 唯一锁 */
    private Lock lock = new ReentrantLock();

    /**
     * 更新游戏服信息
     *
     * @param message
     */
    @RemoteMethod
    public void handleReportServerInfoMessage(ReportServerInfoMessage message, Connection connection) {
        log.info("同步游戏服[{}]信息", message.getServerId());
        this.lock.lock();
        try {
            for (int id : message.getServerId()) {
                sessionManager.updateSession(id, connection.getClientId());
            }

            int oldWorldLevel = systemSysCache.getCrossServerOldGroupWorldLevel();
            int oldGroupOpenServerDay = systemSysCache.getOldGroupOpenServerDay();
            long openServerDay = LocalDateTimeUtil.daysUntil(LocalDate.now(), message.getOpenServerTime().toLocalDate());
            GroupType groupType = GroupType.NEW_SERVER;
            if (openServerDay >= oldGroupOpenServerDay && message.getWorldLevel() >= oldWorldLevel) {
                groupType = GroupType.OLD_SERVER;
            }
            log.info("当前服务器[{}:{}]的世界等级:{}活跃人数:{}开服时间:{} ", message.getServerId(), groupType, message.getWorldLevel(), message.getActivePlayersNumber(), message.getOpenServerTime());
            serverInfoDao.updateServerInfo(message.getServerId()[0], message.getWorldLevel(), message.getActivePlayersNumber(), message.getOpenServerTime(), groupType);
        } finally {
            this.lock.unlock();
        }
    }

    /**
     * 处理请求跨服分组信息
     *
     * @param message
     * @param connection
     */
    @RemoteMethod
    public CrossRegroupMessage handleRequestGroupInfoMessage(RequestCrossGroupMessage message, Connection connection) {
        log.info("收到跨服请求跨服分组消息crossId[{}]", message.getCrossServerId());
        this.lock.lock();
        try {
            CrossCluster crossCluster = crossClusterDao.get();
            List<CrossGroup> groups = crossCluster.getCrossGroups(message.getCrossServerId());
            List<Integer> groupIds = groups.stream().map(group -> group.getGroupId()).collect(Collectors.toList());
            log.info("返回跨服crossServerId:{}分配的跨服分组groupIds:{}", message.getCrossServerId(), groupIds);
            sessionManager.updateCrossSession(message.getCrossServerId(), connection.getClientId());
            return CrossRegroupMessage.of(crossCluster.getSerialNumber(), groups);
        } finally {
            this.lock.unlock();
        }
    }

    /**
     * 处理请求跨服信息
     * @param message
     * @param connection
     */
    @RemoteMethod
    public void handleRequestCrossServerInfoMessage(RequestCrossServerInfoMessage message, Connection connection) {
        log.info("收到游戏服[{}]请求跨服消息!", message.getServerId());
        this.lock.lock();
        try {
            handleReportServerInfoMessage(message.getMessage(), connection);

            CrossCluster crossCluster = crossClusterDao.get();
            CrossGroup group = crossCluster.getServerCrossGroup(message.getServerId());
            if (group == null) {
                log.info("游戏服[{}]没有找到跨服分组准备重新加入组!", message.getServerId());
                ServerInfo serverInfo = serverInfoDao.get(message.getServerId());
                if (serverInfo == null) {
                    log.info("游戏服[{}]信息更新失败，加入跨服失败!", message.getServerId());
                    return;
                } else {
                    log.info("游戏服[{}]信息更新成功!", message.getServerId());
                    group = centerServerWorker.joinToGroup(serverInfo, crossCluster);
                    log.info("游戏服[{}]加入跨服服务器成功!", message.getServerId());
                }
            }

            CrossConfig crossConfig = crossConfigDao.get("crossServerId", group.getCrossServerId());
            log.info("游戏服[{}]被分配到:{}:{}", message.getServerId(), crossConfig.getIp(), crossConfig.getPort());
            log.info("游戏服[{}]连接中心服完毕！", message.getServerId());
            connection.send(PushServerCrossInfoMessage.of(group.getGroupId(), crossConfig.getIp(), crossConfig.getPort()));
        } finally {
            this.lock.unlock();
        }
    }
}
