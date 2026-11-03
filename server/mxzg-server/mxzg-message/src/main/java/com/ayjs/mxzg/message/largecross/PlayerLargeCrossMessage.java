package com.ayjs.mxzg.message.largecross;

import com.ayjs.rpc.PlayerMessage;

/**
 * 玩家跨服消息，支持错误码返回并推送给客户端
 */
public interface PlayerLargeCrossMessage extends PlayerMessage, LargeCrossMessage {
}
