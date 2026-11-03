package com.ayjs.mxzg.gameserver.log.godEquip.observer;

import org.springframework.beans.factory.annotation.Autowired;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.gameserver.log.godEquip.domain.GodEquipLog;
import com.ayjs.mxzg.gameserver.log.godEquip.domain.GodEquipWashLog;
import com.ayjs.mxzg.gameserver.module.godequip.domain.GodEquip;
import com.ayjs.mxzg.gameserver.module.godequip.event.GodEquipAddEvent;
import com.ayjs.mxzg.gameserver.module.godequip.event.GodEquipDeleteEvent;
import com.ayjs.mxzg.gameserver.module.godequip.event.GodEquipImproveEvent;
import com.ayjs.mxzg.template.log.LogEntityFactory;
import com.ayjs.mxzg.template.log.LogService;

/**
 * 神装日志监听
 * @author hyx
 */
@Observer
public class GodEquipLogObserver {

    @Autowired
    private LogEntityFactory logEntityFactory;
    @Autowired
    private LogService logService;

    @Subscribe(async = Subscribe.AsyncType.AsyncLog)
    private void listen(GodEquipImproveEvent event){
        GodEquipWashLog log = logEntityFactory.create(GodEquipWashLog.class);
        log.setRid(event.getRid());
        log.setTime(DateTimeUtil.currentSecond());
        log.setGodEquipId(event.getGodEquipId());
        log.setOldAbility(event.getOldAbility());
        log.setNewAbility(event.getNewAbility());
        logService.addLog(log);
    }

    @Subscribe(async = Subscribe.AsyncType.AsyncLog)
    private void listen(GodEquipAddEvent event) {
    	for(GodEquip equip : event.getEquips()) {
    		GodEquipLog log = logEntityFactory.create(GodEquipLog.class);
    		log.setRid(equip.getRid());
    		log.setSysId(equip.getSysId());
    		log.setDelta(1);
    		log.setCurr(1);
    		log.setTime(TimeDateUtil.getCurrentTimeInt());
    		log.setEvent(event.getGameEvent().getValue());
    		log.setEventDesc(event.getGameEvent().getRemark());
    		log.setPart(equip.getPlace());
    		logService.addLog(log);
    	}
    }
    
    
    @Subscribe(async = Subscribe.AsyncType.AsyncLog)
    private void listen(GodEquipDeleteEvent event) {
    	for(GodEquip equip : event.getEquips()) {
    		GodEquipLog log = logEntityFactory.create(GodEquipLog.class);
    		log.setRid(equip.getRid());
    		log.setSysId(equip.getSysId());
    		log.setDelta(-1);
    		log.setCurr(0);
    		log.setTime(TimeDateUtil.getCurrentTimeInt());
    		log.setEvent(event.getGameEvent().getValue());
    		log.setEventDesc(event.getGameEvent().getRemark());
    		log.setPart(equip.getPlace());
    		logService.addLog(log);
    	}
    }
}
