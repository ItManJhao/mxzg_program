package com.ayjs.mxzg.battle.command;

import com.ayjs.mxzg.battle.model.BattlerDo;
import com.ayjs.mxzg.battle.model.mirror.BattlerVo;
import com.ayjs.mxzg.common.command.Command;

import lombok.Getter;
import lombok.Setter;

/**
 * 玩家pvp战斗
 * @author meiyc
 *
 */
@Getter
@Setter
public class BattlerVoCommand implements Command {

	/** 战斗值对象  */
	private BattlerVo battlerVo;
	
	/** 战斗领域对象 */
	private BattlerDo battlerDo;
	
	
	public static BattlerVoCommand createOf(BattlerVo battlerVo){
		BattlerVoCommand command = new BattlerVoCommand();
		command.setBattlerVo(battlerVo);
		return command;
	}
}
