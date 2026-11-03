package com.ayjs.mxzg.message.module.crusadegroup.group;

import com.ayjs.rpc.RemoteMessage;
import lombok.Value;

/**
 * 讨伐团关闭消息
 */
@Value(staticConstructor = "getInstance")
public class CloseMessage implements RemoteMessage {
}
