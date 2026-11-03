package com.ayjs.mxzg.battle.buff.condition;

import com.ayjs.mxzg.battle.buff.BuffHandler;
import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.config.excel.entity.CBuff;
import com.ayjs.mxzg.protocol.BattleGMsg.BuffInfo.Builder;

/**
 * 抽象的条件处理器
 * @author meiyc
 *
 */
public abstract class AbstractConditionBuffHandler implements BuffHandler {

	@Override
	public void handle(CBuff buff, HeroDo attacker, HeroDo defender, BattleContext context, Builder builder) {
		if(!checkCondition(buff, attacker, defender, context)){
			attacker.interrupt(defender.getUnitId());
		}
	}
	
	/**
	 * 如果条件不满足则中断当前回合对目标的出手
	 * @param buff
	 * @param attacker
	 * @param defender
	 * @return
	 */
	protected abstract boolean checkCondition(CBuff buff, HeroDo attacker, HeroDo defender, BattleContext context);
	
}
