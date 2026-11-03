package com.ayjs.mxzg.message.cross;

import com.ayjs.mxzg.message.center.CenterServerMessage;
import lombok.Value;

/**
 * 跨服连接成功消息，游戏服收到该消息后才能发送后续消息
 */
@Value(staticConstructor = "getInstance")
public class CrossServiceConnectedMessage implements CenterServerMessage {
}
