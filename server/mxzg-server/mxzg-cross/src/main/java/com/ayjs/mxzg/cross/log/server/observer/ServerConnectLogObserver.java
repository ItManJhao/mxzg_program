package com.ayjs.mxzg.cross.log.server.observer;

import cn.hutool.core.collection.CollectionUtil;
import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.cross.log.server.domain.ServerConnectLog;
import com.ayjs.mxzg.cross.module.crossservice.event.Game2CrossConnectedEvent;
import com.ayjs.mxzg.cross.module.crossservice.event.Game2CrossDisconnectedEvent;
import com.ayjs.mxzg.template.log.LogEntityFactory;
import com.ayjs.mxzg.template.log.LogService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import java.time.LocalDateTime;

@Slf4j
@Observer
@Controller
public class ServerConnectLogObserver {

    @Autowired
    private LogEntityFactory logEntityFactory;
    @Autowired
    private LogService logService;

    @Subscribe(async = Subscribe.AsyncType.AsyncLog)
    public void connected(Game2CrossConnectedEvent event) {
        if (CollectionUtil.isEmpty(event.getServerIds())) {
            return;
        }
        ServerConnectLog log = logEntityFactory.create(ServerConnectLog.class);
        log.setServerId(event.getServerIds());
        log.setHost(event.getHost());
        log.setOpTime(LocalDateTime.now());
        log.setStatus(1);
        logService.addLog(log);
    }

    @Subscribe(async = Subscribe.AsyncType.AsyncLog)
    public void disconnected(Game2CrossDisconnectedEvent event) {
        ServerConnectLog log = logEntityFactory.create(ServerConnectLog.class);
        log.setServerId(CollectionUtil.toList(event.getServerId()));
        log.setHost("");
        log.setOpTime(LocalDateTime.now());
        log.setStatus(0);
        logService.addLog(log);
    }
}
