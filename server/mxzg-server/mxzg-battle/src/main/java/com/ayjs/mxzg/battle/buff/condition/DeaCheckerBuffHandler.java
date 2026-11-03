/**
 * 
 */
package com.ayjs.mxzg.battle.buff.condition;

import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.config.excel.entity.CBuff;
import com.ayjs.mxzg.config.struct.BuffType;
import org.springframework.stereotype.Component;

/**
 * 目标是否死亡
 * @author YY
 *
 */
@Component
public class DeaCheckerBuffHandler extends AbstractConditionBuffHandler {

	@Override
	public BuffType getType() {
		return BuffType.BT_DEA;
	}

	@Override
	protected boolean checkCondition(CBuff buff, HeroDo attacker, HeroDo defender, BattleContext context) {
		return defender.isDead();
	}

}
