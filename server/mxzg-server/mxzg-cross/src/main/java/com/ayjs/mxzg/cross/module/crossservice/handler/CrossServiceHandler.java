package com.ayjs.mxzg.cross.module.crossservice.handler;

import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.cross.infrastructure.server.CrossServerLauncher;
import com.ayjs.mxzg.cross.module.crossservice.SessionManager;
import com.ayjs.mxzg.cross.module.crossservice.dao.CrossServerGroupDao;
import com.ayjs.mxzg.cross.module.crossservice.domain.CrossServerGroup;
import com.ayjs.mxzg.cross.module.crossservice.event.CrossRegroupEvent;
import com.ayjs.mxzg.cross.module.crossservice.event.Game2CrossConnectedEvent;
import com.ayjs.mxzg.message.center.CenterServiceConnectedMessage;
import com.ayjs.mxzg.message.center.RequestCrossGroupMessage;
import com.ayjs.mxzg.message.center.dto.CrossGroup;
import com.ayjs.mxzg.message.cross.CrossConnectedSuccessMessage;
import com.ayjs.mxzg.message.cross.CrossRegroupMessage;
import com.ayjs.mxzg.message.cross.ReportIdentityMessage;
import com.ayjs.mxzg.message.cross.UpdateCrossGroupMessage;
import com.ayjs.rpc.annotation.RemoteMethod;
import com.ayjs.rpc.dispatcher.MessageDispatcher;
import com.ayjs.rpc.dispatcher.MessageHandler;
import com.ayjs.rpc.server.Connection;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

/**
 * 跨服消息处理器
 */
@Slf4j
@Component
public class CrossServiceHandler implements MessageHandler {

    @Value("${server.id}")
    private int crossServerId;
    @Autowired
    private EventBus eventBus;
    @Autowired
    private SessionManager sessionManager;
    @Autowired
    private CrossServerGroupDao crossServerGroupDao;
    @Autowired
    private MessageDispatcher messageDispatcher;
    @Autowired
    private CrossServerLauncher crossServerLauncher;

    /**
     * 跨服查询该集群被分配的跨服分组
     *
     * @param message
     */
    @RemoteMethod
    public void handleCenterServiceConnectedMessage(CenterServiceConnectedMessage message) {
        log.info("中心服连接成功!");
        log.info("请求集群分组信息...");
        RequestCrossGroupMessage requestCrossGroupMessage = RequestCrossGroupMessage.of(crossServerId);
        messageDispatcher.dispatch(requestCrossGroupMessage, m -> {
            CrossRegroupMessage msg = (CrossRegroupMessage) m;
            log.info("收到中心服返回的集群分组size:{}", msg.getGroupNum());
            resetGroup(msg);
            crossServerLauncher.start();
        });
    }

    /**
     * 重新设置分组
     *
     * @param message
     */
    private void resetGroup(CrossRegroupMessage message) {
        CrossServerGroup serverGroup = crossServerGroupDao.get();
        if (serverGroup.isRegroup(message.getSerialNumber())) {
            log.info("跨服重新配置分组...");
            serverGroup.reset(message.getSerialNumber(), message.getCrossGroups());
            crossServerGroupDao.update(serverGroup);
            eventBus.post(CrossRegroupEvent.getInstance());
        }
    }

    /**
     * 跨服重组消息
     *
     * @param message
     */
    @RemoteMethod
    public void handleCrossRegroupMessage(CrossRegroupMessage message) {
        log.info("收到跨服重组消息size:{}", message.getGroupNum());
        resetGroup(message);
        log.info("跨服重组配置完毕");
    }

    /**
     * 认证服务器身份
     *
     * @param message
     * @param connection
     */
    @RemoteMethod
    public void handleReportIdentityMessage(ReportIdentityMessage message, Connection connection) {
        log.info("游戏服{}认证完毕！", message.getServerIds());
        sessionManager.updateServerClientId(message.getServerIds(), connection.getClientId());
        connection.send(CrossConnectedSuccessMessage.getInstance());

        eventBus.post(Game2CrossConnectedEvent.of(message.getServerIds(), connection.getRemoteAddress()));
    }

    /**
     * 处理跨服分组修改
     *
     * @param message
     */
    @RemoteMethod
    public void handleUpdateCrossGroupMessage(UpdateCrossGroupMessage message) {
        log.info("收到跨服分组更新消息serverIds:{}！", message.getCrossGroup().getServerIds());
        CrossServerGroup serverGroup = crossServerGroupDao.get();
        CrossGroup group = message.getCrossGroup();
        serverGroup.addGroup(group);
        crossServerGroupDao.update(serverGroup);
    }

}
