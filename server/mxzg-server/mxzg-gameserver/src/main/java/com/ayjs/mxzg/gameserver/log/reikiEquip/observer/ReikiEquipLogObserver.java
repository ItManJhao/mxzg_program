package com.ayjs.mxzg.gameserver.log.reikiEquip.observer;


import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import com.ayjs.mxzg.config.excel.cache.reiki.ReikiEquipSysCache;
import com.ayjs.mxzg.config.excel.entity.reiki.CReikiEquip;
import com.ayjs.mxzg.gameserver.log.reikiEquip.domain.ReikiEquipLog;
import com.ayjs.mxzg.gameserver.module.reikiEquip.domain.ReikiEquip;
import com.ayjs.mxzg.gameserver.module.reikiEquip.event.ReikiEquipActiveEvent;
import com.ayjs.mxzg.gameserver.module.reikiEquip.event.ReikiEquipAddEvent;
import com.ayjs.mxzg.gameserver.module.reikiEquip.event.ReikiEquipDelEvent;
import com.ayjs.mxzg.template.log.LogEntityFactory;
import com.ayjs.mxzg.template.log.LogService;
import org.springframework.beans.factory.annotation.Autowired;

/**
 * 灵器日志监听
 *
 * @author hyx
 */
@Observer
public class ReikiEquipLogObserver {

    @Autowired
    private ReikiEquipSysCache reikiEquipSysCache;
    @Autowired
    private LogEntityFactory logEntityFactory;
    @Autowired
    private LogService logService;


    @Subscribe(async = Subscribe.AsyncType.AsyncLog)
    public void listen(ReikiEquipAddEvent event) {
        for (ReikiEquip reikiEquip : event.getList()) {
            ReikiEquipLog log = logEntityFactory.create(ReikiEquipLog.class);
            log.setRid(event.getRid());
            log.setSysId(reikiEquip.getSysId());
            log.setTime(DateTimeUtil.currentSecond());
            log.setDelta(1);
            log.setCurr(1);
            log.setEvent(event.getGameEvent().getValue());
            log.setEventDesc(event.getGameEvent().getRemark());

            CReikiEquip cReikiEquip = reikiEquipSysCache.getOrThrow(reikiEquip.getSysId());
            log.setPart(cReikiEquip.getPlace());

            logService.addLog(log);
        }

    }

    @Subscribe(async = Subscribe.AsyncType.AsyncLog)
    public void listen(ReikiEquipDelEvent event) {
        for (ReikiEquip reikiEquip : event.getList()) {
            ReikiEquipLog log = logEntityFactory.create(ReikiEquipLog.class);
            log.setRid(event.getRid());
            log.setSysId(reikiEquip.getSysId());
            log.setTime(DateTimeUtil.currentSecond());
            log.setDelta(-1);
            log.setCurr(0);
            log.setEvent(event.getGameEvent().getValue());
            log.setEventDesc(event.getGameEvent().getRemark());

            CReikiEquip cReikiEquip = reikiEquipSysCache.getOrThrow(reikiEquip.getSysId());
            log.setPart(cReikiEquip.getPlace());

            logService.addLog(log);
        }
    }

    @Subscribe(async = Subscribe.AsyncType.AsyncLog)
    public void listen(ReikiEquipActiveEvent event) {
        ReikiEquipLog log = logEntityFactory.create(ReikiEquipLog.class);
        log.setRid(event.getRid());
        log.setSysId(event.getSysId());
        log.setTime(DateTimeUtil.currentSecond());
        log.setDelta(1);
        log.setCurr(1);
        log.setEvent(event.getGameEvent().getValue());
        log.setEventDesc(event.getGameEvent().getRemark());

        CReikiEquip cReikiEquip = reikiEquipSysCache.getOrThrow(event.getSysId());
        log.setPart(cReikiEquip.getPlace());

        logService.addLog(log);

    }

}
