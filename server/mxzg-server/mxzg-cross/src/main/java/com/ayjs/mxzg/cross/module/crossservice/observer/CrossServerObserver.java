package com.ayjs.mxzg.cross.module.crossservice.observer;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.cross.module.crossservice.SessionManager;
import com.ayjs.mxzg.cross.module.crossservice.event.Game2CrossDisconnectedEvent;
import com.ayjs.mxzg.message.cross.AuthenticationIdentityMessage;
import com.ayjs.rpc.event.ServerConnectedEvent;
import com.ayjs.rpc.event.ServerDisconnectedEvent;
import com.ayjs.rpc.server.ConnectionManager;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.util.CollectionUtils;

import java.util.Collection;
import java.util.Objects;

@Slf4j
@Observer
public class CrossServerObserver {

    @Autowired
    private SessionManager serverManager;
    @Autowired
    private ConnectionManager connectionManager;
    @Autowired
    private EventBus eventBus;

    @Subscribe
    public void onServerConnectedEvent(ServerConnectedEvent event) {
        log.info("通知服务器{}:{}进行分区认证", event.getHost(), event.getPort());
        connectionManager.send(event.getClientId(), AuthenticationIdentityMessage.getInstance());
    }

    @Subscribe
    public void onServerConnectedEvent(ServerDisconnectedEvent event) {
        Collection<Integer> serverIds = serverManager.serverDisconnect(event.getClientId());
        if (!CollectionUtils.isEmpty(serverIds)) {
            log.info("游戏服断开链接：{}", serverIds);
        }

        Integer serverId = serverManager.getServerIdBy(event.getClientId());
        if (Objects.nonNull(serverId)) {
            eventBus.post(Game2CrossDisconnectedEvent.of(serverId));
        }
    }
}
