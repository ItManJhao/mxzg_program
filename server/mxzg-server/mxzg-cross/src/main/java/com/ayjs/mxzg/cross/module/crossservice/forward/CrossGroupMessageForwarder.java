package com.ayjs.mxzg.cross.module.crossservice.forward;

import com.ayjs.mxzg.cross.module.crossservice.SessionManager;
import com.ayjs.mxzg.message.center.dto.CrossGroup;
import com.ayjs.mxzg.message.cross.CrossGroupMessage;
import com.ayjs.rpc.client.Request;
import com.ayjs.rpc.forward.MessageForwarder;
import com.ayjs.rpc.server.Connection;
import com.ayjs.rpc.server.ConnectionManager;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.Collection;
import java.util.Set;

/**
 * 跨服组消息转发器
 */
@Slf4j
@Component
public class CrossGroupMessageForwarder implements MessageForwarder<CrossGroupMessage> {

    @Autowired
    private SessionManager sessionManager;
    @Autowired
    private ConnectionManager connectionManager;

    @Override
    public Collection<Integer> forward(Request request, Connection connection) {
        CrossGroup crossGroup = sessionManager.getGroupByClientId(connection.getClientId());
        Set<Integer> groupClientIds = sessionManager.getGroupClientIdsByClientId(connection.getClientId());
        log.info("收到跨服消息{}转发到跨服组{},clientIds[{}]", request.getMessage().getClass(), crossGroup.getGroupId(), groupClientIds);
        connectionManager.forwardRequest(groupClientIds, request);
        return groupClientIds;
    }
}
