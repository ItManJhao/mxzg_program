package com.ayjs.mxzg.module.battle;

import com.ayjs.mxzg.common.command.Receivers;
import com.ayjs.mxzg.common.command.annotation.Invoker;
import com.ayjs.mxzg.module.battle.command.RemoveBattleReportCommand;
import com.ayjs.mxzg.module.battle.command.SaveBattleReportCommand;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class BattleReportReceiver implements Receivers{

	@Autowired
	private BattleReportManager reportManager;

	@Invoker
	public void onSaveBattleReportCommand(SaveBattleReportCommand command){
		reportManager.save(command.getReport());
	}
	
	@Invoker
	public void onRemoveBattleReportCommand(RemoveBattleReportCommand command){
		reportManager.delete(command.getBattleId());
	}
	
}
