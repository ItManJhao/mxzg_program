/**
 * 
 */
package com.ayjs.mxzg.battle.buff.condition;

import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.DamageResult;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.config.excel.entity.CBuff;
import com.ayjs.mxzg.config.struct.BuffType;
import org.springframework.stereotype.Component;

/**
 * 本次伤害是否造成暴击
 */
@Component
public class CritCheckerBuffHandler extends AbstractConditionBuffHandler {

	@Override
	public BuffType getType() {
		return BuffType.BT_CRIT;
	}

	@Override
	protected boolean checkCondition(CBuff buff, HeroDo attacker, HeroDo defender, BattleContext context) {
		DamageResult result = attacker.getResult();
		if(result == null){
			return false;
		}
		return result.isCrit();
	}

}
