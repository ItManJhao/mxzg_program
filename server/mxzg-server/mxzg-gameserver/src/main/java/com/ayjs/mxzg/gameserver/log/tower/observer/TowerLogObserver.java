package com.ayjs.mxzg.gameserver.log.tower.observer;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.cache.TowerrewardSysCache;
import com.ayjs.mxzg.gameserver.log.tower.domain.TowerLog;
import com.ayjs.mxzg.gameserver.module.tower.event.TowerChallengeEvent;
import com.ayjs.mxzg.template.log.LogEntityFactory;
import com.ayjs.mxzg.template.log.LogService;
import org.springframework.beans.factory.annotation.Autowired;

import java.time.LocalDateTime;

@Observer
public class TowerLogObserver {

	@Autowired
	private LogEntityFactory logEntityFactory;
	@Autowired
    private LogService logService;
	@Autowired
	private TowerrewardSysCache towerRewardSysCache;
	
	@Subscribe(async = Subscribe.AsyncType.AsyncLog)
	private void listen(TowerChallengeEvent event) {
		TowerLog log = logEntityFactory.create(TowerLog.class);
        log.setRid(event.getRid());
        log.setRidFighting(event.getFighting());
        log.setRidLevel(event.getLevel());
        log.setStage(event.getStage());
        log.setResult(event.isWin());
        log.setStageFighting(towerRewardSysCache.getOrThrow(event.getStage()).getBattle_advice());
        log.setDateTime(LocalDateTime.now());
        log.setTime(TimeDateUtil.getCurrentTimeInt());
        logService.addLog(log);
	}
}
