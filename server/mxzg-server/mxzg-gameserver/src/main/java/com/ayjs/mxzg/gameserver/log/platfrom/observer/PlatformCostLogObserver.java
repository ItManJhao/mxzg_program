package com.ayjs.mxzg.gameserver.log.platfrom.observer;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.gameserver.log.platfrom.domain.PlatformCostLog;
import com.ayjs.mxzg.gameserver.web.event.PlatformCostEvent;
import com.ayjs.mxzg.template.log.LogEntityFactory;
import com.ayjs.mxzg.template.log.LogService;
import org.springframework.beans.factory.annotation.Autowired;

@Observer
public class PlatformCostLogObserver {

    @Autowired
    private LogEntityFactory logEntityFactory;
    @Autowired
    private LogService logService;

    @Subscribe(async = Subscribe.AsyncType.AsyncLog)
    private void listen(PlatformCostEvent event) {
        PlatformCostLog log = logEntityFactory.create(PlatformCostLog.class);
        log.setRid(event.getRid());
        log.setTime(TimeDateUtil.getCurrentTimeInt());
        if (event.getCostItem() != null) {
            log.setCostItem(event.getCostItem());
        }
        if (event.getCostRecharge() != null) {
            log.setCostRecharge(event.getCostRecharge());
        }
        log.setTime(TimeDateUtil.getCurrentTimeInt());
        logService.addLog(log);
    }
}
