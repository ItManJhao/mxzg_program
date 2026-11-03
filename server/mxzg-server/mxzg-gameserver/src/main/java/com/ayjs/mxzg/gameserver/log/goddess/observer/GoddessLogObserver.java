package com.ayjs.mxzg.gameserver.log.goddess.observer;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import com.ayjs.mxzg.gameserver.log.goddess.domain.GoddessUnlockLog;
import com.ayjs.mxzg.gameserver.module.fetter.event.GoddessUnlockEvent;
import com.ayjs.mxzg.template.log.LogEntityFactory;
import com.ayjs.mxzg.template.log.LogService;
import org.springframework.beans.factory.annotation.Autowired;

/**
 * 羁绊解锁日志
 * @author hyx
 */
@Observer
public class GoddessLogObserver {

    @Autowired
    private LogService logService;
    @Autowired
    private LogEntityFactory logEntityFactory;


    @Subscribe(async = Subscribe.AsyncType.AsyncLog)
    public void listen(GoddessUnlockEvent event){
        GoddessUnlockLog log = logEntityFactory.create(GoddessUnlockLog.class);
        log.setGoddessType(event.getConfigId());
        log.setRid(event.getRid());
        log.setTime(DateTimeUtil.currentSecond());
        logService.addLog(log);
    }
}
