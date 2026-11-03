/**
 * 
 */
package com.ayjs.mxzg.gameserver.log.rune.observer;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.util.JsonUtil;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.gameserver.log.rune.domain.RuneLog;
import com.ayjs.mxzg.gameserver.module.rune.domain.RuneInfo;
import com.ayjs.mxzg.gameserver.module.rune.event.RuneAddEvent;
import com.ayjs.mxzg.gameserver.module.rune.event.RuneDeleteEvent;
import com.ayjs.mxzg.template.log.LogEntityFactory;
import com.ayjs.mxzg.template.log.LogService;
import org.springframework.beans.factory.annotation.Autowired;

/**
 * @author YY
 *
 */
@Observer
public class RuneLogObserver {

	@Autowired
    private LogService logService;
    @Autowired
    private LogEntityFactory logEntityFactory;
    
    @Subscribe(async = Subscribe.AsyncType.AsyncLog)
    private void listen(RuneAddEvent event) {
        for (RuneInfo rune : event.getRunes()) {
        	RuneLog runeLog = createRuneLog(rune, event.getGameEvent(), 1);
            logService.addLog(runeLog);
        }
    }
    
    @Subscribe(async = Subscribe.AsyncType.AsyncLog)
    private void listen(RuneDeleteEvent event) {
        for (RuneInfo rune : event.getRunes()) {
        	RuneLog runeLog = createRuneLog(rune, event.getGameEvent(), -1);
            logService.addLog(runeLog);
        }
    }
    
    private RuneLog createRuneLog(RuneInfo rune, GameEvent gameEvent, int num) {
    	RuneLog runeLog = logEntityFactory.create(RuneLog.class);
    	runeLog.setRid(rune.getRid());
    	runeLog.setType(rune.getTypeId());
    	runeLog.setAbilityId(rune.getAbilityId());
    	runeLog.setSkillMap(JsonUtil.toJson(rune.getSkillMap()));
        runeLog.setEvent(gameEvent.getValue());
        runeLog.setDelta(num);
        runeLog.setTime(TimeDateUtil.getCurrentTimeInt());
        runeLog.setEventDesc(gameEvent.getRemark());
        return runeLog;
    }
}
