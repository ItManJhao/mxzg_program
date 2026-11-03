package com.ayjs.mxzg.battle.recever;


import com.ayjs.mxzg.battle.BattleIDBuilder;
import com.ayjs.mxzg.battle.command.BattleCommand;
import com.ayjs.mxzg.battle.event.BattleEvent;
import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.BattleResult;
import com.ayjs.mxzg.battle.model.BattleType;
import com.ayjs.mxzg.battle.service.BattleService;
import com.ayjs.mxzg.common.command.Receivers;
import com.ayjs.mxzg.common.command.annotation.Invoker;
import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.config.excel.cache.BattleRoundAdditionSysCache;
import com.ayjs.mxzg.config.excel.entity.CBattleRoundAddition;
import com.ayjs.mxzg.config.struct.AttributeType;
import com.ayjs.mxzg.config.struct.GameEvent;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import java.util.Collection;
import java.util.HashMap;
import java.util.Map;

@Component
public class BattleReceivers implements Receivers {

	@Value("${server.id}")
	private String serverId;
	@Autowired
	private EventBus eventBus;
	@Autowired
	private BattleService battleService;
	@Autowired
	private BattleRoundAdditionSysCache battleRoundAdditionSysCache;
	
	
	@Invoker
	public void onBattleCommand(BattleCommand command){
		String battleId = BattleIDBuilder.getNewBattleId(serverId, command.getBattleType());
		BattleContext context = BattleContext.createOf(battleId, command.getBattleType(), command.getAttacker(), command.getDefender(), command.getMaxRoundNum(), command.getConditions());
		setRoundAddition(command.getBattleType(), context);
		battleService.battle(context);
		command.setResult(BattleResult.valueOf(context));
		if(command.getBattleType() != BattleType.HANG_UP){
			eventBus.post(BattleEvent.of(command.getAttacker().getPlayerId(), command.getDefender().getPlayerId(),
					battleId, command.getBattleType(), command.getResult().isWin(), GameEvent.BATTLE));
		}
	}

	/**
	 * 设置回合加成
	 * @param battleType
	 * @param context
	 */
	private void setRoundAddition(BattleType battleType, BattleContext context){
		Collection<CBattleRoundAddition> additions = battleRoundAdditionSysCache.getAdditionByType(battleType.getValue());
		Map<Integer,Map<AttributeType, Long>> roundAddition = new HashMap<>();
		for (CBattleRoundAddition addition : additions) {
			roundAddition.put(addition.getRound(), addition.getAddition());
		}
		context.setRoundAddition(roundAddition);
	}

}
