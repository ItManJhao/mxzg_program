package com.ayjs.mxzg.largecross.servergroup.observer;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.largecross.servergroup.SessionManager;
import com.ayjs.mxzg.message.largecross.LargeServerConnectedMessage;
import com.ayjs.rpc.event.ServerConnectedEvent;
import com.ayjs.rpc.event.ServerDisconnectedEvent;
import com.ayjs.rpc.server.ConnectionManager;
import org.springframework.beans.factory.annotation.Autowired;

@Observer
public class LargeServerObserver {

    @Autowired
    private SessionManager sessionManager;
    @Autowired
    private ConnectionManager connectionManager;

    @Subscribe
    public void listen(ServerConnectedEvent event) {
        connectionManager.send(event.getClientId(), LargeServerConnectedMessage.getInstance());
    }

    @Subscribe
    public void listen(ServerDisconnectedEvent event) {
        sessionManager.serverDisconnect(event.getClientId());
    }

}
