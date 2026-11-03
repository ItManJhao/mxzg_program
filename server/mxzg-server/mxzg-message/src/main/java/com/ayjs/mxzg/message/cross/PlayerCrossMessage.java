package com.ayjs.mxzg.message.cross;

import com.ayjs.rpc.PlayerMessage;

/**
 * 玩家跨服消息，支持错误码返回并推送给客户端
 */
public interface PlayerCrossMessage extends PlayerMessage, CrossMessage {
}
