package com.ayjs.rpc.event;

import lombok.Getter;
import lombok.Setter;
import lombok.Value;

/**
 * 服务器断开连接
 */
@Getter
@Setter
@Value(staticConstructor = "of")
public class ServerDisconnectedEvent {

    /**
     * 连接id
     */
    private int clientId;
}
