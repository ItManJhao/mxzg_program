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
 * 驱灵
 * @author meiyc
 *
 */
@Component
public class ExorcismBuffHandler extends AbstractArtTriggerBuffHandler {

	@Override
	public BuffType getType() {
		return BuffType.BT_EXORCISM;
	}


	@Override
	public void trigger(BuffDo buff, HeroDo beTrigger, HeroDo target, BattleContext context) {
		if(target.haveBuff(BuffType.BT_HOLY_SPIRIT)){
			int damageAdd = buff.getBuff().getValues().get(0);
			DamageResult result = beTrigger.getResult();
			long damage = AttributeUtil.addPercent(result.getDamage(), damageAdd);
			result.updateDamage(damage);
		}
	}

}
