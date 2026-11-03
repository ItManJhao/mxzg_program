package com.ayjs.rpc.server;

import com.ayjs.rpc.HeartbeatMessage;
import com.ayjs.rpc.annotation.RemoteMethod;
import com.ayjs.rpc.dispatcher.MessageHandler;
import org.springframework.stereotype.Component;

@Component
public class DefaultMessageHandler implements MessageHandler {

    @RemoteMethod
    public void handleHeartbeatMessage(HeartbeatMessage message) {
    }

}
