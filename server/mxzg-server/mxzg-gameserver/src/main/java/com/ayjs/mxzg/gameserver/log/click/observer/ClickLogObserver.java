package com.ayjs.mxzg.gameserver.log.click.observer;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.gameserver.log.click.domain.ClickLog;
import com.ayjs.mxzg.gameserver.module.click.event.ClickEvent;
import com.ayjs.mxzg.template.log.LogEntityFactory;
import com.ayjs.mxzg.template.log.LogService;
import org.springframework.beans.factory.annotation.Autowired;

import java.time.LocalDateTime;

/**
 * 庇护所日志
 *
 * @author hyx
 */
@Observer
public class ClickLogObserver {

    @Autowired
    private LogService logService;
    @Autowired
    private LogEntityFactory logEntityFactory;

    @Subscribe
    private void listen(ClickEvent event) {
        ClickLog clickLog = logEntityFactory.create(ClickLog.class);
        clickLog.setRid(event.getRid());
        clickLog.setClickCode(event.getClickCode());
        clickLog.setClickTime(LocalDateTime.now());
        logService.addLog(clickLog);
    }


}
