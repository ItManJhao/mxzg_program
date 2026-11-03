package com.ayjs.mxzg.gameserver.log.blessingPool.observer;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import com.ayjs.mxzg.gameserver.log.blessingPool.domain.BlessingPoolLog;
import com.ayjs.mxzg.gameserver.module.blessingPool.event.BlessingPoolDoneEvent;
import com.ayjs.mxzg.template.log.LogEntityFactory;
import com.ayjs.mxzg.template.log.LogService;
import org.springframework.beans.factory.annotation.Autowired;

/**
 * 许愿池日志监听
 * @author hyx
 */
@Observer
public class BlessingPoolLogObserver {

    @Autowired
    private LogService logService;
    @Autowired
    private LogEntityFactory logEntityFactory;

    @Subscribe
    private void listen(BlessingPoolDoneEvent event){
        BlessingPoolLog blessingPoolLog = logEntityFactory.create(BlessingPoolLog.class);
        blessingPoolLog.setRid(event.getRid());
        blessingPoolLog.setTime(DateTimeUtil.currentSecond());
        blessingPoolLog.setPoolType(event.getType().getValue());
        blessingPoolLog.setNum(event.getCount());
        logService.addLog(blessingPoolLog);
    }
}
