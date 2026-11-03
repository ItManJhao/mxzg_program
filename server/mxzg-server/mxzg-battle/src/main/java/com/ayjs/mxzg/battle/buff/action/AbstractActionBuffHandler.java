package com.ayjs.mxzg.battle.buff.action;

import com.ayjs.mxzg.battle.buff.BuffHandler;
import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.battle.model.SkillDo;
import com.ayjs.mxzg.config.excel.entity.CBuff;
import com.ayjs.mxzg.protocol.BattleGMsg.BuffInfo.Builder;

/**
 * 抽象的行为buff
 * @author meiyc
 *
 */
public abstract class AbstractActionBuffHandler implements BuffHandler {
	
	@Override
	public void handle(CBuff buff, HeroDo attacker, HeroDo defender, BattleContext context, Builder builder) {
		SkillDo skillDo = getSkill(buff, attacker);
		attacker.addCounterattackTarget(defender, skillDo);
		context.addCounterattack(attacker);
	}
	
	/**
	 * 获取技能
	 * @param buff
	 * @param attacker
	 * @return
	 */
	protected abstract SkillDo getSkill(CBuff buff, HeroDo attacker);
	
}
