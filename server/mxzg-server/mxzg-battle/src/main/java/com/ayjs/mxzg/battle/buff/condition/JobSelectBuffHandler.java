package com.ayjs.mxzg.battle.buff.condition;

import com.ayjs.mxzg.battle.model.BattleContext;
import org.springframework.stereotype.Component;

import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.config.excel.entity.CBuff;
import com.ayjs.mxzg.config.struct.BuffType;

/**
 * 指定目标职业才会生效
 * @author meiyc
 *
 */
@Component
public class JobSelectBuffHandler extends AbstractConditionBuffHandler {

	@Override
	public BuffType getType() {
		return BuffType.BT_JOB_SELECT;
	}

	
	@Override
	protected boolean checkCondition(CBuff buff, HeroDo attacker, HeroDo defender, BattleContext context) {
		return buff.getValues().contains(defender.getJob().getValue());
	}

}
