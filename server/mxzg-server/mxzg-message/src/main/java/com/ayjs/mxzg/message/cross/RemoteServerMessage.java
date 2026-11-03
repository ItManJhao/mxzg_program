package com.ayjs.mxzg.message.cross;

/**
 * 远程游戏服消息
 */
public interface RemoteServerMessage extends CrossMessage {

    /**
     * 消息目的地的游戏分区id
     * @return
     */
    int serverId();
}
