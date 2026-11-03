/**
 *
 */
package com.ayjs.mxzg.gameserver.log.battle.observer;

import com.ayjs.mxzg.battle.event.BattleEvent;
import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.gameserver.log.battle.domain.BattleLog;
import com.ayjs.mxzg.template.log.LogEntityFactory;
import com.ayjs.mxzg.template.log.LogService;
import org.springframework.beans.factory.annotation.Autowired;

/**
 * @author YY
 *
 */
@Observer
public class BattleLogObserver {

    @Autowired
    private LogService logService;
    @Autowired
    private LogEntityFactory logEntityFactory;

    @Subscribe(async = Subscribe.AsyncType.AsyncLog)
    private void listen(BattleEvent event) {
		BattleLog battleLog = logEntityFactory.create(BattleLog.class);
		battleLog.setRid(event.getRid());
		battleLog.setBattleId(event.getBattleId());
		battleLog.setBattleType(event.getBattleType().getValue());
		battleLog.setOpponent(event.getOpponent());
		battleLog.setWin(event.isWin());
		battleLog.setTime(TimeDateUtil.getCurrentTimeInt());
		logService.addLog(battleLog);
    }

}
