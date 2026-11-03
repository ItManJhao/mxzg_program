package com.ayjs.rpc.event;

import lombok.Getter;
import lombok.Setter;

/**
 * 服务器连接事件
 */
@Getter
@Setter
public class ServerConnectedEvent {

    /**
     * 客户端id
     */
    private int clientId;

    /**
     * ip
     */
    private String host;

    /**
     * 端口
     */
    private int port;

    public static ServerConnectedEvent createOf(int clientId, String host, int port) {
        ServerConnectedEvent event = new ServerConnectedEvent();
        event.setClientId(clientId);
        event.setHost(host);
        event.setPort(port);
        return event;
    }
}
