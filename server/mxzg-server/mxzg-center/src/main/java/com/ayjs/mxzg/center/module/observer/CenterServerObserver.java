package com.ayjs.mxzg.center.module.observer;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.message.center.CenterServiceConnectedMessage;
import com.ayjs.rpc.event.ServerConnectedEvent;
import com.ayjs.rpc.server.ConnectionManager;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;

@Slf4j
@Observer
public class CenterServerObserver {

    @Autowired
    private ConnectionManager connectionManager;

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void onServerConnectedEvent(ServerConnectedEvent event) {
        log.info("通知服务器{}:{}中心服已经建立连接", event.getHost(), event.getPort());
        connectionManager.send(event.getClientId(), CenterServiceConnectedMessage.getInstance());
    }
}
