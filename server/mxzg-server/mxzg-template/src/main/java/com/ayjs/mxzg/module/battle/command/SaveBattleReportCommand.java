package com.ayjs.mxzg.module.battle.command;

import com.ayjs.mxzg.common.command.Command;
import com.ayjs.mxzg.protocol.BattleGMsg.BattleReport;
import lombok.Value;

/**
 * 保存战报指令
 * @author meiyc
 *
 */
@Value(staticConstructor = "of")
public class SaveBattleReportCommand implements Command {

	/** 要保存的战报 */
	private BattleReport report;
	
}
