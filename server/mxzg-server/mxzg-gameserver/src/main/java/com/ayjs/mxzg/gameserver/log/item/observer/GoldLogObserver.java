/**
 * 
 */
package com.ayjs.mxzg.gameserver.log.item.observer;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.gameserver.log.item.domain.GoldLog;
import com.ayjs.mxzg.gameserver.module.backpack.event.GoldAddEvent;
import com.ayjs.mxzg.gameserver.module.backpack.event.GoldCostEvent;
import com.ayjs.mxzg.template.log.LogEntityFactory;
import com.ayjs.mxzg.template.log.LogService;
import org.springframework.beans.factory.annotation.Autowired;

/**
 * @author YY
 *
 */
@Observer
public class GoldLogObserver {

	@Autowired
	private LogService logService;
	@Autowired
    private LogEntityFactory logEntityFactory;
	
	@Subscribe(async = Subscribe.AsyncType.AsyncLog)
	private void listen(GoldAddEvent event) {
		GoldLog log = logEntityFactory.create(GoldLog.class);
		log.setRid(event.getRid());
		log.setDelta(event.getAddCount());
		log.setCurr(event.getCurr());
		log.setTime(TimeDateUtil.getCurrentTimeInt());
		log.setEvent(event.getGameEvent().getValue());
		log.setEventDesc(event.getGameEvent().getRemark());
		logService.addLog(log);
    }
	
    @Subscribe(async = Subscribe.AsyncType.AsyncLog)
    private void listen(GoldCostEvent event) {
    	GoldLog log = logEntityFactory.create(GoldLog.class);
    	log.setRid(event.getRid());
    	log.setDelta(-event.getCostCount());
    	log.setCurr(event.getCurr());
    	log.setTime(TimeDateUtil.getCurrentTimeInt());
    	log.setEvent(event.getGameEvent().getValue());
    	log.setEventDesc(event.getGameEvent().getRemark());
		logService.addLog(log);
    }
}
