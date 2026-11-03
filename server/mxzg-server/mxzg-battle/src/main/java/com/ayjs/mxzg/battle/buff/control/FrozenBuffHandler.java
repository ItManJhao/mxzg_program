package com.ayjs.mxzg.battle.buff.control;

import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.BuffDo;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.config.struct.BuffType;
import org.springframework.stereotype.Component;

/**
 * 冰冻
 * @author meiyc
 *
 */
@Component
public class FrozenBuffHandler extends AbstractControlBuffHandler {


	@Override
	public BuffType getType() {
		return BuffType.BT_FROZEN;
	}

	@Override
	protected void callback(BuffDo buffDo, HeroDo attacker, HeroDo defender, BattleContext context) {
		super.callback(buffDo, attacker, defender, context);
		int beAttackCount = buffDo.getBuff().getValue()[0];
		beAttackCount = beAttackCount == 0 ? 999 : beAttackCount;
		buffDo.setValue(beAttackCount);
	}

	@Override
	public void trigger(BuffDo buff, HeroDo betrigger, HeroDo target, BattleContext context) {
		buff.addValue(-1);
		if(buff.getValue() <= 0){
			buffHelper.removeBuff(buff, betrigger, context);
			battleTrigger.trigger(BuffType.BT_BREAK_ICE, target, betrigger, context);
		}
	}
}
