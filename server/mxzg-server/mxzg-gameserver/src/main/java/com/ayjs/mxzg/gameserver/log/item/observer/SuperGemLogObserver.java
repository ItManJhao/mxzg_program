/**
 *
 */
package com.ayjs.mxzg.gameserver.log.item.observer;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.gameserver.log.item.domain.SuperGemLog;
import com.ayjs.mxzg.gameserver.module.backpack.event.SuperGemAddEvent;
import com.ayjs.mxzg.gameserver.module.backpack.event.SuperGemCostEvent;
import com.ayjs.mxzg.template.log.LogEntityFactory;
import com.ayjs.mxzg.template.log.LogService;
import org.springframework.beans.factory.annotation.Autowired;

/**
 * @author tangyangbo
 */
@Observer
public class SuperGemLogObserver {

    @Autowired
    private LogService logService;
    @Autowired
    private LogEntityFactory logEntityFactory;

    @Subscribe(async = Subscribe.AsyncType.AsyncLog)
    private void listen(SuperGemAddEvent event) {
        SuperGemLog log = logEntityFactory.create(SuperGemLog.class);
        log.setRid(event.getRid());
        log.setDelta(event.getAddCount());
        log.setCurr(event.getCurr());
        log.setTime(TimeDateUtil.getCurrentTimeInt());
        log.setEvent(event.getGameEvent().getValue());
        log.setEventDesc(event.getGameEvent().getRemark());
        logService.addLog(log);
    }

    @Subscribe(async = Subscribe.AsyncType.AsyncLog)
    private void listen(SuperGemCostEvent event) {
        SuperGemLog log = logEntityFactory.create(SuperGemLog.class);
        log.setRid(event.getRid());
        log.setDelta(-event.getCostCount());
        log.setCurr(event.getCurr());
        log.setTime(TimeDateUtil.getCurrentTimeInt());
        log.setEvent(event.getGameEvent().getValue());
        log.setEventDesc(event.getGameEvent().getRemark());
        logService.addLog(log);
    }
}
