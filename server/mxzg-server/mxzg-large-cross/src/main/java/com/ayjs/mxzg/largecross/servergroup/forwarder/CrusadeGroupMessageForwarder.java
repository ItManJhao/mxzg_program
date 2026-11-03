package com.ayjs.mxzg.largecross.servergroup.forwarder;

import com.ayjs.mxzg.largecross.servergroup.SessionManager;
import com.ayjs.mxzg.message.largecross.CrusadeGroupMessage;
import com.ayjs.mxzg.message.largecross.RemoteLargeCrossMessage;
import com.ayjs.rpc.client.Request;
import com.ayjs.rpc.forward.MessageForwarder;
import com.ayjs.rpc.server.Connection;
import com.ayjs.rpc.server.ConnectionManager;
import com.google.common.collect.Lists;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.Collection;
import java.util.Collections;
import java.util.List;

/**
 * 玩家远程消息转发器
 */
@Slf4j
@Component
public class CrusadeGroupMessageForwarder implements MessageForwarder<CrusadeGroupMessage> {

    @Autowired
    private SessionManager sessionManager;
    @Autowired
    private ConnectionManager connectionManager;

    @Override
    public Collection<Integer> forward(Request request, Connection connection) {
        RemoteLargeCrossMessage message = (RemoteLargeCrossMessage)request.getMessage();
        Integer clientId = sessionManager.getClientIdBy(message.serverId());
        if(clientId == null){
            log.error("游戏服[{}]已经断开消息转发失败{}", message.serverId(), message.getClass());
            return Collections.emptySet();
        }
        List<Integer> clientIds = Lists.newArrayList(clientId);
        connectionManager.forwardRequest(clientIds, request);
        return clientIds;
    }
}
