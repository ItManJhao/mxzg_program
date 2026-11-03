package com.ayjs.mxzg.battle.command;


import com.ayjs.mxzg.battle.BattleConstant;
import com.ayjs.mxzg.battle.model.BattleCondition;
import com.ayjs.mxzg.battle.model.BattleResult;
import com.ayjs.mxzg.battle.model.BattleType;
import com.ayjs.mxzg.battle.model.BattlerDo;
import com.ayjs.mxzg.common.command.Command;
import com.ayjs.mxzg.protocol.BattleGMsg.BattleReport;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;
import org.springframework.util.CollectionUtils;

import java.util.Collections;
import java.util.List;

/**
 * 战斗指令
 * @author meiyc
 *
 */
@Setter
@Getter
@AllArgsConstructor
public class BattleCommand implements Command {
	
	
	/** 战斗类型 {@link BattleType}} */
	private BattleType battleType;
	
	/** 攻方玩家 */
	private BattlerDo attacker;
	
	/** 守方玩家 */
	private BattlerDo defender;
	
	/** 战场上下文 */
	private BattleResult result;
	
	/** 最大回合数 */
	private int maxRoundNum;

	/** 战斗结束条件 */
	private List<BattleCondition> conditions;
	
	public static BattleCommand createOf(BattleType battleType, BattlerDo attacker, BattlerDo defender){
		return new BattleCommand(battleType, attacker, defender, null, BattleConstant.BATTLE_MAX_ROUND, Collections.emptyList());
	}

	public static BattleCommand createOf(BattleType battleType, BattlerDo attacker, BattlerDo defender, List<BattleCondition> conditions){
		conditions = CollectionUtils.isEmpty(conditions) ? Collections.emptyList() : conditions;
		return new BattleCommand(battleType, attacker, defender, null, BattleConstant.BATTLE_MAX_ROUND, conditions);
	}
	
	/**
	 * 获取战报
	 * @return
	 */
	public BattleReport getReport(){
		return this.result.getReport();
	}
}
