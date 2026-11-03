package com.ayjs.mxzg.gameserver.log.item.observer;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.gameserver.log.item.domain.TavernAdventureLog;
import com.ayjs.mxzg.gameserver.module.task.event.TavernAdventureEvent;
import com.ayjs.mxzg.template.log.LogEntityFactory;
import com.ayjs.mxzg.template.log.LogService;
import org.springframework.beans.factory.annotation.Autowired;

/**
 * 酒馆日志
 * @author hyx
 */
@Observer
public class TavernAdventureLogObserver {

    @Autowired
    private LogService logService;
    @Autowired
    private LogEntityFactory logEntityFactory;


    /**
     * 监听冒险点数
     * @param event
     */
    @Subscribe(async = Subscribe.AsyncType.AsyncLog)
    private void listen(TavernAdventureEvent event) {
        TavernAdventureLog itemLog = logEntityFactory.create(TavernAdventureLog.class);
        itemLog.setRid(event.getRid());
        itemLog.setTime(TimeDateUtil.getCurrentTimeInt());
        itemLog.setEvent(event.getEvent().getValue());
        itemLog.setEventDesc(event.getEvent().getRemark());
        itemLog.setCurr(event.getAfterAdventureCount());
        if (event.getAddCount() > 0) {
            itemLog.setDelta(event.getAddCount());
        } else if (event.getCostCount() > 0) {
            itemLog.setDelta(-event.getCostCount());
        }
        logService.addLog(itemLog);
    }


}
