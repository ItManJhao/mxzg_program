package com.ayjs.mxzg.gameserver.module.recharge.observer;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.recharge.service.RechargeService;
import com.ayjs.mxzg.gameserver.module.server.struct.RechargeLimit;
import com.ayjs.mxzg.gameserver.web.event.RechargeLimitChangeEvent;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.Objects;

@Slf4j
@Observer
public class RechargeObserver {

    @Autowired
    private ContextManager contextManager;
    @Autowired
    private RechargeService rechargeService;

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void onEventAreaId(RechargeLimitChangeEvent event) {

        RechargeLimit rechargeLimit = rechargeService.getRechargeLimit();
        if (Objects.isNull(rechargeLimit)) {
            log.info("RechargeLimitChangeEvent RechargeLimit is null.");
            return;
        }
        contextManager.getOnlineRids().forEach(rid -> {
            contextManager.write(rid, CmdCode._30003, rechargeService.getGResRechargeLimitInfo(rid, rechargeLimit));
        });
    }

}
