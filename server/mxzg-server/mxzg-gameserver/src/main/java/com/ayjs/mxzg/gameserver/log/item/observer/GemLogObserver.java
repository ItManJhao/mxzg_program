/**
 * 
 */
package com.ayjs.mxzg.gameserver.log.item.observer;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.gameserver.log.item.domain.GemLog;
import com.ayjs.mxzg.gameserver.module.backpack.event.GemAddEvent;
import com.ayjs.mxzg.gameserver.module.backpack.event.GemCostEvent;
import com.ayjs.mxzg.template.log.LogEntityFactory;
import com.ayjs.mxzg.template.log.LogService;
import org.springframework.beans.factory.annotation.Autowired;

/**
 * @author YY
 *
 */
@Observer
public class GemLogObserver {

	@Autowired
	private LogService logService;
	@Autowired
    private LogEntityFactory logEntityFactory;
	
	@Subscribe(async = Subscribe.AsyncType.AsyncLog)
	private void listen(GemAddEvent event) {
		GemLog gemLog = logEntityFactory.create(GemLog.class);
		gemLog.setRid(event.getRid());
		gemLog.setDelta(event.getAddCount());
		gemLog.setCurr(event.getCurr());
		gemLog.setTime(TimeDateUtil.getCurrentTimeInt());
		gemLog.setEvent(event.getGameEvent().getValue());
		gemLog.setEventDesc(event.getGameEvent().getRemark());
		logService.addLog(gemLog);
    }
	
    @Subscribe(async = Subscribe.AsyncType.AsyncLog)
    private void listen(GemCostEvent event) {
    	GemLog gemLog = logEntityFactory.create(GemLog.class);
    	gemLog.setRid(event.getRid());
    	gemLog.setDelta(-event.getCostCount());
    	gemLog.setCurr(event.getCurr());
    	gemLog.setTime(TimeDateUtil.getCurrentTimeInt());
    	gemLog.setEvent(event.getGameEvent().getValue());
    	gemLog.setEventDesc(event.getGameEvent().getRemark());
		logService.addLog(gemLog);
    }
}
