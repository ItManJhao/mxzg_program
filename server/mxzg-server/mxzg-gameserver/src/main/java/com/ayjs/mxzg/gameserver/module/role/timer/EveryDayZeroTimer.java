package com.ayjs.mxzg.gameserver.module.role.timer;

import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.module.dreamland.service.DreamlandRankService;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.Promotion067WeekendKoiService;
import com.ayjs.mxzg.gameserver.module.role.event.ZeroTimeEvent;
import com.ayjs.mxzg.template.scheduler.service.AbstractCronTask;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.ArrayList;

/**
 * 零点定时器
 *
 * @Author: CWJ
 * @Date: 2019/10/22
 **/
@Slf4j
@Component
public class EveryDayZeroTimer extends AbstractCronTask {
    @Autowired
    ContextManager contextManager;
    @Autowired
    EventBus eventBus;
    @Autowired
    private DreamlandRankService dreamlandRankService;
    @Autowired
    private Promotion067WeekendKoiService promotion067WeekendKoiService;

    @Override
    public void run() {

        log.info("---------------------执行0点定时器---------------------");

        new ArrayList<>(contextManager.getAllOnline()).stream().filter(playerContext -> playerContext.getId() > 0)
                .forEach(playerContext -> eventBus.post(ZeroTimeEvent.of(playerContext.getId())));

        dreamlandRankService.zeroSendMail();
        promotion067WeekendKoiService.sendKoiReward();
    }

    @Override
    public Object identity() {
        return "EveryDayZeroTimer";
    }

    @Override
    public String expression() {
        return "0 0 0 * * ?";
    }
}
