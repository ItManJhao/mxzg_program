package com.ayjs.mxzg.center.module.rechargeLimit.observer;

import com.ayjs.mxzg.center.module.rechargeLimit.domain.CenterRechargeLimit;
import com.ayjs.mxzg.center.module.rechargeLimit.event.CenterRechargeLimitChargeEvent;
import com.ayjs.mxzg.center.module.rechargeLimit.service.CenterRechargeLimitService;
import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.message.module.rechargeLimit.ReposeCenterRechargeLimitMessage;
import com.ayjs.rpc.event.ServerConnectedEvent;
import com.ayjs.rpc.server.ConnectionManager;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;

@Slf4j
@Observer
public class CenterRechargeLimitObserver {

    @Autowired
    private ConnectionManager connectionManager;
    @Autowired
    private CenterRechargeLimitService centerRechargeLimitService;

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void onServerConnectedEvent(ServerConnectedEvent event) {
        CenterRechargeLimit rechargeLimit = centerRechargeLimitService.get();

        log.info("通知服务器{}:{} 发送充值限制信息", event.getHost(), event.getPort());
        connectionManager.send(event.getClientId(),
                ReposeCenterRechargeLimitMessage.of(rechargeLimit.getTotalRecharge(),
                        rechargeLimit.getAreas(), rechargeLimit.getLoginAreas()));
    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void onServerConnectedEvent(CenterRechargeLimitChargeEvent event) {
        CenterRechargeLimit rechargeLimit = centerRechargeLimitService.get();

        log.info("通知所有服务器,发送充值限制信息");
        connectionManager.callAll(ReposeCenterRechargeLimitMessage.of(rechargeLimit.getTotalRecharge(),
                rechargeLimit.getAreas(), rechargeLimit.getLoginAreas()));
    }
}
