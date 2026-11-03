package com.ayjs.mxzg.gameserver.module.battle.receiver;

import com.ayjs.mxzg.battle.command.BattleCommand;
import com.ayjs.mxzg.common.command.Receivers;
import com.ayjs.mxzg.common.command.annotation.Invoker;
import com.ayjs.mxzg.common.command.annotation.Invoker.Priority;
import com.ayjs.mxzg.config.excel.cache.BattleTypeSysCache;
import com.ayjs.mxzg.config.excel.entity.CBattleType;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class BattleReceiver implements Receivers{

	@Autowired
	private BattleTypeSysCache battleTypeSysCache;
	
	@Invoker(value = Priority.HIGHEST)
	public void onBattleCommand(BattleCommand command){
		CBattleType battleType = battleTypeSysCache.getOrThrow(command.getBattleType().getValue());
		command.setMaxRoundNum(battleType.getRound_max());
	}
}
