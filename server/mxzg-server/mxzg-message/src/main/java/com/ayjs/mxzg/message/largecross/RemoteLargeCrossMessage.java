package com.ayjs.mxzg.message.largecross;

/**
 * 远程游戏服消息
 */
public interface RemoteLargeCrossMessage extends LargeCrossMessage {

    /**
     * 消息目的地的游戏分区id
     * @return
     */
    int serverId();
}
