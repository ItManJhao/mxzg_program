package com.ayjs.mxzg.cross.module.crossservice.event;

import lombok.Value;

/**
 * 游戏服断开跨服事件
 */
@Value(staticConstructor = "of")
public class Game2CrossDisconnectedEvent {

    /**
     * 服务器id
     */
    int serverId;
}
