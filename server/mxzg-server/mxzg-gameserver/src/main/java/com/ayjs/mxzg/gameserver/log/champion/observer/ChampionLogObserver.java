/**
 * 
 */
package com.ayjs.mxzg.gameserver.log.champion.observer;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.event.annotation.Subscribe.AsyncType;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.gameserver.log.champion.domain.ChampionGuessCoinLog;
import com.ayjs.mxzg.module.champion.ChampionGuessEvent;
import com.ayjs.mxzg.template.log.LogEntityFactory;
import com.ayjs.mxzg.template.log.LogService;
import org.springframework.beans.factory.annotation.Autowired;

/**
 * @author YY
 *
 */
@Observer
public class ChampionLogObserver {

	@Autowired
	private LogService logService;
	@Autowired
    private LogEntityFactory logEntityFactory;
	
	@Subscribe(async = AsyncType.AsyncLog)
	private void listen(ChampionGuessEvent event) {
		ChampionGuessCoinLog log = logEntityFactory.create(ChampionGuessCoinLog.class);
		log.setRid(event.getRid());
		log.setDelta(event.getDelta());
		log.setCurr(event.getCurr());
		log.setTime(TimeDateUtil.getCurrentTimeInt());
		log.setEvent(event.getGameEvent().getValue());
		log.setEventDesc(event.getGameEvent().getRemark());
		log.setPeriod(event.getBattle().getPeriod());
		log.setBattleRound(event.getBattle().getBattleRound());
		log.setWhichWin(event.getBattle().getWhichWin());
		log.setGuessType(event.getGuessType());
		log.setRound(event.getBattle().getRound());
		logService.addLog(log);
	}
}
