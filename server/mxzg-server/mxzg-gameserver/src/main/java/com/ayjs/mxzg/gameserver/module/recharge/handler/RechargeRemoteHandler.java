package com.ayjs.mxzg.gameserver.module.recharge.handler;

import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.gameserver.module.recharge.service.RechargeService;
import com.ayjs.mxzg.gameserver.module.server.struct.RechargeLimit;
import com.ayjs.mxzg.gameserver.web.event.RechargeLimitChangeEvent;
import com.ayjs.mxzg.message.module.rechargeLimit.ReposeCenterRechargeLimitMessage;
import com.ayjs.rpc.annotation.Remote;
import com.ayjs.rpc.annotation.RemoteMethod;
import com.ayjs.rpc.dispatcher.MessageHandler;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import java.util.HashSet;
import java.util.Objects;
import java.util.Set;

@Slf4j
@Remote
@Controller
public class RechargeRemoteHandler implements MessageHandler {

    @Autowired
    private RechargeService rechargeService;
    @Autowired
    private EventBus eventBus;

    /**
     * 充值限制条件
     *
     * @param message
     */
    @RemoteMethod
    public void handleReposeCenterRechargeLimitMessage(ReposeCenterRechargeLimitMessage message) {
        log.info("RechargeRemoteHandler.handleReposeCenterRechargeLimitMessage充值限制条件消息");
        long totalRecharge = message.getTotalRecharge();
        Set<String> areas = message.getAreas();
        Set<String> loginAreas = message.getLoginAreas();

        RechargeLimit rechargeLimit = rechargeService.getRechargeLimit();
        if (Objects.isNull(rechargeLimit)) {
            rechargeLimit = new RechargeLimit();
            rechargeLimit.setAreas(new HashSet<>());
            rechargeLimit.setLoginAreas(new HashSet<>());
            rechargeLimit.setLevelInfos(new HashSet<>());
        }
        rechargeLimit.setTotalRecharge(totalRecharge);
        if (Objects.isNull(areas)) {
            rechargeLimit.setAreas(new HashSet<>());
        } else {
            rechargeLimit.setAreas(areas);
        }
        if (Objects.isNull(loginAreas)) {
            rechargeLimit.setLoginAreas(new HashSet<>());
        } else {
            rechargeLimit.setLoginAreas(loginAreas);
        }
        rechargeService.updateRechargeLimit(rechargeLimit);

        eventBus.post(RechargeLimitChangeEvent.of(rechargeLimit.getTotalRecharge(), rechargeLimit.getAreas(),
                rechargeLimit.getLoginAreas(), rechargeLimit.getLevelInfos()));
    }
}
