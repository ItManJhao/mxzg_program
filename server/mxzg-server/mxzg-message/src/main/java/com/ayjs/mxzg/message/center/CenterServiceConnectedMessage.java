package com.ayjs.mxzg.message.center;

import lombok.Value;

/**
 * 中心服连接成功消息，所有服收到该消息后才能做逻辑
 */
@Value(staticConstructor = "getInstance")
public class CenterServiceConnectedMessage implements CenterServerMessage {
}
