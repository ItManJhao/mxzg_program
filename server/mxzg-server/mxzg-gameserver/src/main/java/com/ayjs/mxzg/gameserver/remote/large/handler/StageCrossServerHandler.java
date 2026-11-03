package com.ayjs.mxzg.gameserver.remote.large.handler;

import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.gameserver.infrastructure.constant.ServerConfig;
import com.ayjs.mxzg.gameserver.remote.large.domain.LargeServerGroup;
import com.ayjs.mxzg.gameserver.remote.large.event.StageCrossConnectEvent;
import com.ayjs.mxzg.gameserver.remote.large.service.StageCrossGroupService;
import com.ayjs.mxzg.message.largecross.ConnectionFinishMessage;
import com.ayjs.mxzg.message.largecross.LargeServerConnectedMessage;
import com.ayjs.mxzg.message.largecross.ReportServerInfoMessage;
import com.ayjs.rpc.annotation.RemoteMethod;
import com.ayjs.rpc.dispatcher.MessageDispatcher;
import com.ayjs.rpc.dispatcher.MessageHandler;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.Objects;

/**
 * @Author: CWJ
 * @Date: 2020/6/19
 **/

@Slf4j
@Component
public class StageCrossServerHandler implements MessageHandler {

    @Autowired
    private MessageDispatcher messageDispatcher;
    @Autowired
    private ServerConfig serverConfig;
    @Autowired
    private StageCrossGroupService stageCrossGroupService;
    @Autowired
    private EventBus eventBus;

    @RemoteMethod
    public void connect(LargeServerConnectedMessage message) {
        Integer[] serverIds = serverConfig.getSubServerIds();
        if (Objects.isNull(serverIds) || serverIds.length < 1) {
            serverIds = new Integer[1];
            serverIds[0] = serverConfig.getServerId();
        }
        messageDispatcher.dispatch(ReportServerInfoMessage.of(serverConfig.getServerId(), serverIds), res -> {
            ConnectionFinishMessage response = (ConnectionFinishMessage) res;
            LargeServerGroup largeServerGroup = stageCrossGroupService.get();
            largeServerGroup.setGroupId(response.getGroupId());
            stageCrossGroupService.update(largeServerGroup);
            if(response.isSuccess()){
                eventBus.post(StageCrossConnectEvent.of(response.getGroupId()));
            }
        });
    }

}
