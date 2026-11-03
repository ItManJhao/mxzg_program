package com.ayjs.rpc.server;

import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.rpc.RemoteMessage;
import com.ayjs.rpc.client.Request;
import com.ayjs.rpc.client.ResponseFuture;
import com.ayjs.rpc.event.ServerConnectedEvent;
import com.ayjs.rpc.event.ServerDisconnectedEvent;
import lombok.extern.slf4j.Slf4j;
import org.apache.poi.ss.formula.functions.T;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.net.InetSocketAddress;
import java.util.Collection;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentMap;

/**
 * TCP连接管理器
 *
 * @author Alias
 * @date 2017年12月11日 下午4:08:46
 */
@Slf4j
@Component
public class ConnectionManager {

    @Autowired
    private EventBus eventBus;

    private final ThreadLocal<Connection> connection = new ThreadLocal<>();

    /** 保存所有连接 */
    private final ConcurrentMap<Integer, Connection> connections = new ConcurrentHashMap<>();

    /**
     * 增加连接
     *
     * @param conn
     */
    public void addConnection(Connection conn) {
        InetSocketAddress address = (InetSocketAddress) conn.getChannel().remoteAddress();
        log.info("连接成功{}:{}", address.getHostString(), address.getPort());
        connections.put(conn.getClientId(), conn);
        eventBus.post(ServerConnectedEvent.createOf(conn.getClientId(), address.getHostString(), address.getPort()));
    }

    /**
     * 移除连接
     *
     * @param clientId
     */
    public void removeConnection(Integer clientId) {
        Connection connection = connections.remove(clientId);
        if (connection != null) {
            log.info("断开链接ClientId:{}", clientId);
            eventBus.post(ServerDisconnectedEvent.of(connection.getClientId()));
        }
    }

    public void removeCurrentConnection() {
        connection.remove();
    }

    public Connection connection(Integer clientId) {
        return connections.get(clientId);
    }

    public void currentConnection(Connection connection) {
        this.connection.set(connection);
    }

    public Connection currentConnection() {
        return this.connection.get();
    }


    public ResponseFuture<T> call(Integer clientId, RemoteMessage message) {
        Connection connection = connection(clientId);
        if (connection == null) {
            log.error("分服链接id " + clientId + "不存在");
            return null;
        }
        return connection.call(message);
    }

    public void send(Integer clientId, RemoteMessage message) {
        Connection connection = connection(clientId);
        if (connection == null) {
            log.error("分服链接id " + clientId + "不存在");
            return;
        }
        connection.send(message);
    }

    public void sendTo(Collection<Integer> clientIds, RemoteMessage message) {
        clientIds.forEach(clientId -> send(clientId, message));
    }

    /**
     * 响应请求
     *
     * @param clientId
     * @param response
     */
    public void forwardResponse(Integer clientId, Response response) {
        Connection connection = connection(clientId);
        if (connection == null) {
            log.error("分服链接id " + clientId + "不存在");
        } else {
            connection.callbackResponse(response);
        }
    }

    /**
     * 转发请求
     *
     * @param clientIds
     * @param request
     */
    public void forwardRequest(Collection<Integer> clientIds, Request request) {
        clientIds.forEach(clientId -> {
            Connection connection = connection(clientId);
            if (connection == null) {
                log.error("分服链接id " + clientId + "不存在");
            } else {
                connection.forwardRequest(request);
            }
        });
    }

    public void callAll(RemoteMessage message) {
        connections.forEach((k, connection) -> {
            if (connection != null) {
                connection.call(message);
            }
        });
    }

    public void call(Collection<Integer> clientIds, RemoteMessage message) {
        clientIds.forEach(clientId -> call(clientId, message));
    }
}
