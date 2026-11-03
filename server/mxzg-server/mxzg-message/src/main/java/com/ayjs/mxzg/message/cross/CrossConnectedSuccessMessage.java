package com.ayjs.mxzg.message.cross;

import com.ayjs.rpc.RemoteMessage;
import lombok.Value;

/**
 * 跨服连接成功
 */
@Value(staticConstructor = "getInstance")
public class CrossConnectedSuccessMessage implements RemoteMessage {
}
