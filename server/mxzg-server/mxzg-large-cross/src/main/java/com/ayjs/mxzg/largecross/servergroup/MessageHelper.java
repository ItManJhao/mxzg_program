package com.ayjs.mxzg.largecross.servergroup;

import com.ayjs.mxzg.message.cross.RemoteServerMessage;
import com.ayjs.rpc.RemoteMessage;
import com.ayjs.rpc.server.ConnectionManager;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.Set;

/**
 * 跨服消息帮助类
 */
@Slf4j
@Component
public class MessageHelper {

    @Autowired
    private SessionManager serverManager;
    @Autowired
    private ConnectionManager connectionManager;

    /**
     * 推送玩家消息
     *
     * @param message
     */
    public void pushToMessage(RemoteServerMessage message) {
        Integer clientId = serverManager.getClientIdBy(message.serverId());
        if(clientId == null){
            log.error("服务器[{}]未连接，消息发送失败{}", message.serverId(), message.getClass());
            return;
        }
        connectionManager.send(clientId, message);
    }

    /**
     * 推送消息到跨服组
     *
     * @param groupId
     * @param message
     */
    public void pushToGroupMessage(int groupId, RemoteMessage message) {
        Set<Integer> clientIds = serverManager.getGroupClientIdsByGroupId(groupId);
        connectionManager.sendTo(clientIds, message);
    }

    /**
     * 推送消息到所有已连接的服务器
     *
     * @param message
     */
    public void pushToAll(RemoteMessage message) {
        connectionManager.callAll(message);
    }
}
