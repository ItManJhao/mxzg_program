package com.ayjs.mxzg.center.module.forward;

import com.ayjs.mxzg.center.module.SessionManager;
import com.ayjs.mxzg.center.module.dao.CrossClusterDao;
import com.ayjs.mxzg.center.module.domain.CrossCluster;
import com.ayjs.mxzg.message.center.FullServerMessage;
import com.ayjs.rpc.client.Request;
import com.ayjs.rpc.forward.MessageForwarder;
import com.ayjs.rpc.server.Connection;
import com.ayjs.rpc.server.ConnectionManager;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.Collection;

/**
 * 全服消息转发器
 */
@Component
public class FullServerMessageForwarder implements MessageForwarder<FullServerMessage> {

    @Autowired
    private CrossClusterDao crossClusterDao;
    @Autowired
    private SessionManager sessionManager;
    @Autowired
    private ConnectionManager connectionManager;

    @Override
    public Collection<Integer> forward(Request request, Connection connection) {
        CrossCluster crossCluster = crossClusterDao.get();
        Collection<Integer> clientIds = sessionManager.getAllServerClientId();
        connectionManager.forwardRequest(clientIds, request);
        return clientIds;
    }
}
