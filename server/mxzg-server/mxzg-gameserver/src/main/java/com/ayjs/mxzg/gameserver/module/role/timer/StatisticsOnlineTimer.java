package com.ayjs.mxzg.gameserver.module.role.timer;

import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.util.SymbolConstants;
import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.module.role.event.StatisticsOnlineEvent;
import com.ayjs.mxzg.template.scheduler.service.AbstractCronTask;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

/**
 * 在线人数
 */
@Slf4j
@Component
public class StatisticsOnlineTimer extends AbstractCronTask {

    @Autowired
    private EventBus eventBus;
    @Autowired
    private ContextManager contextManager;

    @Override
    public Object identity() {
        return "StatisticsOnlineTimer";
    }

    @Override
    public String expression() {
        return "0 0/3 * * * ?";
    }

    @Override
    public void run() {
        int count = (int) contextManager.getAllOnline().stream().filter(playerContext -> playerContext.getId() > 0)
                .map(PlayerContext::getRemoteAddress)
                .filter(ip -> !ip.equals(SymbolConstants.EMPTY)).distinct().count();
        StatisticsOnlineEvent event = StatisticsOnlineEvent.of(contextManager.onlineNum(), count, DateTimeUtil.currentSecond());
        log.debug("online number event:{}", event.toString());
        eventBus.post(event);
    }
}
