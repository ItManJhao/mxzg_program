package com.ayjs.mxzg.module.battle.command;

import com.ayjs.mxzg.common.command.Command;
import lombok.Value;

/**
 * 移除战报指令
 * @author meiyc
 *
 */
@Value(staticConstructor = "of")
public class RemoveBattleReportCommand implements Command {

	/** 移除的战报id */
	private String battleId;
	
}
