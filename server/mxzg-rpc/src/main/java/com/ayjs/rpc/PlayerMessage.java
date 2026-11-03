package com.ayjs.rpc;


/**
 * 标记该消息为一个玩家消息，该消息如果在消息处理时抛出ErrorCodeException 则会被回调回游戏服并且推送错误码到客户端
 */
public interface PlayerMessage extends RemoteMessage {

    /**
     * 角色id
     * @return
     */
    long getRid();

}
