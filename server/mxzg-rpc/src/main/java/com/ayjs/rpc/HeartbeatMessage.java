package com.ayjs.rpc;

import lombok.Value;

@Value(staticConstructor = "getInstance")
public class HeartbeatMessage implements RemoteMessage {
}
