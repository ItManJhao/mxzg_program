package com.ayjs.mxzg.largecross.servergroup.handler;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.largecross.servergroup.SessionManager;
import com.ayjs.mxzg.largecross.servergroup.domain.CrossServerGroup;
import com.ayjs.mxzg.largecross.servergroup.event.ServerInfoEvent;
import com.ayjs.mxzg.largecross.servergroup.service.ServerGroupService;
import com.ayjs.mxzg.message.largecross.ConnectionFinishMessage;
import com.ayjs.mxzg.message.largecross.ReportServerInfoMessage;
import com.ayjs.rpc.annotation.RemoteMethod;
import com.ayjs.rpc.dispatcher.MessageHandler;
import com.ayjs.rpc.server.Connection;
import com.google.common.collect.Lists;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.Objects;

/**
 * @Author: CWJ
 * @Date: 2020/6/19
 **/
@Component
@Observer
@Slf4j
public class LargeServerHandler implements MessageHandler {

    @Autowired
    private SessionManager sessionManager;
    @Autowired
    private ServerGroupService serverGroupService;
    @Autowired
    private EventBus eventBus;

    /**
     * 报告服务器信息
     *
     * @param req
     * @param connection
     * @return
     */
    @RemoteMethod
    public ConnectionFinishMessage handleReportServerInfoMessage(ReportServerInfoMessage req, Connection connection) {
        log.info("游戏服{}连接跨服服务器！", req.getServerId());
        CrossServerGroup crossServerGroup = serverGroupService.get();
        Integer groupId = crossServerGroup.getServerGroup().get(req.getServerId());
        if (Objects.isNull(groupId)) {
            log.error("游戏服{}没有分配跨服组", req.getServerId());
            return ConnectionFinishMessage.of(0);
        }

        sessionManager.updateServerClientId(Lists.newArrayList(req.getServerIds()), connection.getClientId());

        eventBus.post(ServerInfoEvent.of(req.getServerId(), Lists.newArrayList(req.getServerIds())));

        log.info("游戏服{}连接跨服服务器group={}", req.getServerId(), groupId);
        return ConnectionFinishMessage.of(groupId);
    }

}
