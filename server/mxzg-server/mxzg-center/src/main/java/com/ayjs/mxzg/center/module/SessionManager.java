package com.ayjs.mxzg.center.module;

import com.alibaba.fastjson.JSON;
import com.ayjs.mxzg.config.excel.cache.CrossServerSysCache;
import com.ayjs.mxzg.config.excel.entity.CCrossServer;
import com.ayjs.rpc.RemoteMessage;
import com.ayjs.rpc.server.Connection;
import com.ayjs.rpc.server.ConnectionManager;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.Collection;
import java.util.Objects;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentMap;
import java.util.stream.Collectors;

/**
 * 游戏服回合管理
 */
@Slf4j
@Component
public class SessionManager {

    @Autowired
    private CrossServerSysCache crossServerSysCache;

    @Autowired
    private ConnectionManager connectionManager;

    /**
     * ServerId映射的链接id
     */
    private ConcurrentMap<Integer, Integer> serverClientId = new ConcurrentHashMap<>();

    /**
     * 跨服id映射的链接id
     */
    private ConcurrentMap<Integer, Integer> crossClientId = new ConcurrentHashMap<>();

    /**
     * 更新会话id
     *
     * @param serverId
     * @param clientId
     */
    public void updateSession(int serverId, int clientId) {
        log.info("链接更新serverId:{}的clientId:{}", serverId, clientId);
        this.serverClientId.put(serverId, clientId);
        if (serverId == 1) {
            for (Integer sid : this.serverClientId.keySet()) {
                Integer cId = this.serverClientId.getOrDefault(sid, 0);
                Connection connection = connectionManager.connection(cId);
                if (connection == null) {
                    log.error("服务器id={}, clientId={},连接为null", sid, cId);
                } else {
                    if (connection.getChannel() == null) {
                        log.error("服务器id={}, clientId={},连接通道为null", sid, cId);
                    } else {
                        log.error("服务器id={}, clientId={},连接状态{}", sid, cId, connection.getChannel().isActive());
                    }
                }
            }
        }
    }

    /**
     * 更新跨服会话id
     *
     * @param crossId
     * @param clientId
     */
    public void updateCrossSession(int crossId, int clientId) {
        log.info("链接更新crossId:{}的clientId:{}", crossId, clientId);
        this.crossClientId.put(crossId, clientId);

    }

    /**
     * 获取所有服务器连接
     *
     * @return
     */
    public Collection<Integer> getAllServerClientId() {
        return this.serverClientId.values().stream().collect(Collectors.toSet());
    }

    /**
     * 获取所有跨服客户端连接
     *
     * @return
     */
    public Collection<Integer> getAllCrossClientId() {
        return this.crossClientId.values();
    }

    /**
     * 获取所有跨服id
     *
     * @return
     */
    public Collection<Integer> getAllCrossId() {
        return this.crossClientId.keySet();
    }

    /**
     * 根据跨服id获取客户端id
     *
     * @param crossId
     * @return
     */
    public int getClientIdByCrossId(int crossId) {
        return this.crossClientId.getOrDefault(crossId, 0);
    }

    /**
     * 根据服id获取客户端id
     *
     * @param serverId
     * @return
     */
    public int getClientIdByServerId(int serverId) {
        Integer clientId = getClientId(serverId);
        return clientId == null ? 0 : clientId;
    }


    /**
     * 推送消息到到跨服
     *
     * @param crossServerId
     * @param message
     * @param <T>
     */
    public <T extends RemoteMessage> void pushMessageToCross(int crossServerId, T message) {
        Integer clientId = this.crossClientId.get(crossServerId);
        if (clientId != null) {
            pushByClientId(clientId, message);
        } else {
            log.info("跨服[{}]未连接", crossServerId);
        }
    }

    public Integer getClientId(int serverId) {
        int mergeServerId = serverId;

        CCrossServer config = crossServerSysCache.getByServerId(serverId);
        if(Objects.nonNull(config)){
            mergeServerId = config.getMerge_server_id() == 0 ? serverId : config.getMerge_server_id();
        } else {
            log.error("服务器{}的合服后的server id 异常,没有找到合服后的serverId", serverId);
        }

        return this.serverClientId.get(mergeServerId);
    }

    /**
     * 推送消息到服务器
     *
     * @param serverId
     * @param message
     * @param <T>
     */
    public <T extends RemoteMessage> void pushMessageToServer(int serverId, T message) {
        Integer clientId = getClientId(serverId);
        if (clientId != null) {
            pushByClientId(clientId, message);
        } else {
            log.info("服务器[{}]未连接", serverId);
        }
    }

    /**
     * 根据客户端id推送消息
     *
     * @param clientId
     * @param message
     * @param <T>
     */
    public <T extends RemoteMessage> void pushByClientId(Integer clientId, T message) {
        Connection connection = connectionManager.connection(clientId);
        if (connection != null) {
            connection.send(message);
        } else {
            log.info("connection为null消息{}推送失败clientId={}", JSON.toJSON(message), clientId);
        }
    }

}
