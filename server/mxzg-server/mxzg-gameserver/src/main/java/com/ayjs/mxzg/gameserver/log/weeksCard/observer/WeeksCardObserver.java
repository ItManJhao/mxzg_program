package com.ayjs.mxzg.gameserver.log.weeksCard.observer;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.gameserver.log.weeksCard.domain.WeeksCardLog;
import com.ayjs.mxzg.gameserver.module.timeLimitItem.domain.WeeksCardInfo;
import com.ayjs.mxzg.gameserver.module.timeLimitItem.event.WeeksCardEvent;
import com.ayjs.mxzg.template.log.LogEntityFactory;
import com.ayjs.mxzg.template.log.LogService;
import org.springframework.beans.factory.annotation.Autowired;


@Observer
public class WeeksCardObserver {

    @Autowired
    private LogEntityFactory logEntityFactory;
    @Autowired
    private LogService logService;


    @Subscribe(async = Subscribe.AsyncType.AsyncLog)
    private void listen(WeeksCardEvent event) {
        for (WeeksCardInfo weeksCardInfo : event.getWeeksCardInfos()) {
            WeeksCardLog log = logEntityFactory.create(WeeksCardLog.class);
            log.setRid(weeksCardInfo.getRid());
            log.setActiveTime(weeksCardInfo.getActiveTime());
            log.setItemType(weeksCardInfo.getItemType());
            log.setCardId(weeksCardInfo.getId());
            log.setEndTime(weeksCardInfo.getEndTime());
            log.setTime(TimeDateUtil.getCurrentTimeInt());
            logService.addLog(log);
        }
    }
}
