package com.ayjs.mxzg.gameserver.remote.center.handler;

import com.ayjs.mxzg.gameserver.module.server.service.ServerParamService;
import com.ayjs.mxzg.gameserver.module.worldLevel.manager.WorldLevelManager;
import com.ayjs.mxzg.gameserver.remote.cross.CrossServerManager;
import com.ayjs.mxzg.gameserver.remote.cross.dao.CrossServerGroupDao;
import com.ayjs.mxzg.gameserver.remote.cross.domain.CrossServerGroup;
import com.ayjs.mxzg.message.center.CenterServiceConnectedMessage;
import com.ayjs.mxzg.message.center.PushServerCrossInfoMessage;
import com.ayjs.mxzg.message.center.ReportServerInfoMessage;
import com.ayjs.mxzg.message.center.RequestCrossServerInfoMessage;
import com.ayjs.rpc.annotation.RemoteMethod;
import com.ayjs.rpc.dispatcher.MessageDispatcher;
import com.ayjs.rpc.dispatcher.MessageHandler;
import com.ayjs.rpc.server.Connection;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

/**
 * 中心服消息处理器
 */
@Slf4j
@Component
public class CenterMessageHandler implements MessageHandler {

    @Value("${server.id}")
    private int serverId;
    @Autowired
    private CrossServerGroupDao crossServerGroupDao;
    @Autowired
    private MessageDispatcher messageDispatcher;
    @Autowired
    private CrossServerManager crossServerManager;
    @Autowired
    private WorldLevelManager worldLevelManager;

    /**
     * 跨服查询该集群被分配的跨服分组
     *
     * @param message
     */
    @RemoteMethod
    public void handleCenterServiceConnectedMessage(CenterServiceConnectedMessage message, Connection connection) {
        log.info("请求集群分组信息");
        ReportServerInfoMessage serverInfo = worldLevelManager.buildServerInfoMessage();
        messageDispatcher.dispatch(RequestCrossServerInfoMessage.of(serverId, serverInfo));
    }

    /**
     * 跨服查询该集群被分配的跨服分组
     *
     * @param message
     */
    @RemoteMethod
    public void handleServerCrossInfoMessage(PushServerCrossInfoMessage message, Connection connection) {
        log.info("收到跨服返回的跨服信息group:[{}]ip{}:{}", message.getGroupId(), message.getCrossServerHost(), message.getPort());
        CrossServerGroup crossServerGroup = crossServerGroupDao.get();
        crossServerGroup.update(message.getGroupId(), message.getCrossServerHost(), message.getPort());
        crossServerGroupDao.update(crossServerGroup);
        crossServerManager.reconnection();
    }

}
