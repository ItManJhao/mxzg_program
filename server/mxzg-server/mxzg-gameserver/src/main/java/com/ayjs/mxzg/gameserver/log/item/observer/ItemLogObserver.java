/**
 * 
 */
package com.ayjs.mxzg.gameserver.log.item.observer;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.cache.ItemSysCache;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.gameserver.log.item.domain.ItemLog;
import com.ayjs.mxzg.gameserver.module.backpack.event.ItemAddEvent;
import com.ayjs.mxzg.gameserver.module.backpack.event.ItemCostEvent;
import com.ayjs.mxzg.template.log.LogEntityFactory;
import com.ayjs.mxzg.template.log.LogService;
import org.springframework.beans.factory.annotation.Autowired;

/**
 * @author YY
 *
 */
@Observer
public class ItemLogObserver {

	@Autowired
	private LogService logService;
	@Autowired
    private LogEntityFactory logEntityFactory;
	@Autowired
	private ItemSysCache itemSysCache;
	
	@Subscribe(async = Subscribe.AsyncType.AsyncLog)
	private void listen(ItemAddEvent event) {
		int nowTime = TimeDateUtil.getCurrentTimeInt();
		for(ImmutableThing thing : event.getAddValue()) {
			Long curr = event.getCurrMap().get(thing.getItem_type());
			ItemLog itemLog = logEntityFactory.create(ItemLog.class);
			itemLog.setRid(event.getRid());
			itemLog.setType(thing.getItem_type());
			itemLog.setDelta(thing.getItem_num());
			itemLog.setCurr(curr);
			itemLog.setTime(nowTime);
			itemLog.setEvent(event.getGameEvent().getValue());
			itemLog.setEventDesc(event.getGameEvent().getRemark());
			itemLog.setName(itemSysCache.getOrThrow(thing.getItem_type()).getNote());
			logService.addLog(itemLog);
		}
    }
	
    @Subscribe(async = Subscribe.AsyncType.AsyncLog)
    private void listen(ItemCostEvent event) {
    	int nowTime = TimeDateUtil.getCurrentTimeInt();
    	for(ImmutableThing thing : event.getCostList()) {
    		if(thing.getItem_num() <= 0) {
    			continue;
    		}
			Long curr = event.getCurrMap().get(thing.getItem_type());
			ItemLog itemLog = logEntityFactory.create(ItemLog.class);
			itemLog.setRid(event.getRid());
			itemLog.setType(thing.getItem_type());
			itemLog.setDelta(-thing.getItem_num());
			itemLog.setCurr(curr);
			itemLog.setTime(nowTime);
			itemLog.setEvent(event.getGameEvent().getValue());
			itemLog.setEventDesc(event.getGameEvent().getRemark());
			itemLog.setName(itemSysCache.getOrThrow(thing.getItem_type()).getNote());
			logService.addLog(itemLog);
		}
    }
}
