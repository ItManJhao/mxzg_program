package com.ayjs.mxzg.battle.buff.trigger.restraint;

import com.ayjs.mxzg.battle.buff.trigger.AbstractArtTriggerBuffHandler;
import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.BuffDo;
import com.ayjs.mxzg.battle.model.DamageResult;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.battle.util.AttributeUtil;
import com.ayjs.mxzg.config.struct.BuffType;
import org.springframework.stereotype.Component;

/**
 * 闪避
 * @author meiyc
 *
 */
@Component
public class DodgeBuffHandler extends AbstractArtTriggerBuffHandler {

	@Override
	public BuffType getType() {
		return BuffType.BT_DODGE;
	}

	@Override
	public void trigger(BuffDo buff, HeroDo beTrigger, HeroDo target, BattleContext context) {
		if(target.haveBuff(BuffType.BT_STORM)){
			int damageReduce = buff.getBuff().getValues().get(0);
			DamageResult result = target.getResult();
			long damage = AttributeUtil.addPercent(result.getDamage(), damageReduce);
			result.updateDamage(Math.abs(damage));
		}
	}

}
