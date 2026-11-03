/**
 * 
 */
package com.ayjs.mxzg.battle.buff.trigger;

import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.BuffDo;
import com.ayjs.mxzg.battle.model.DamageResult;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.battle.util.AttributeUtil;
import com.ayjs.mxzg.common.util.RandomUtils;
import com.ayjs.mxzg.config.struct.AttributeType;
import com.ayjs.mxzg.config.struct.BuffType;
import org.springframework.stereotype.Component;

/**
 * @author YY
 *
 */
@Component
public class PardonBuffHandler extends AbstractArtTriggerBuffHandler {

	@Override
	public BuffType getType() {
		return BuffType.BT_PARDON;
	}

	@Override
	public void trigger(BuffDo buff, HeroDo beTrigger, HeroDo target, BattleContext context) {
		//攻击方打出的伤害
		DamageResult result = target.getResult();
		long maxHp = beTrigger.getAttribute(AttributeType.MAX_HP);
		int damageRate = (int)((double)result.getDamage() / maxHp * 10000);
		if(Math.abs(damageRate) < buff.getBuff().getValue()[0]) {
			return;
		}
		int rate = buff.getBuff().getValue()[1];
		double randomValue = AttributeUtil.calPercent(rate);
		if(RandomUtils.isHit(randomValue)) {
			result.setDamage((long)(result.getDamage() * (1 - AttributeUtil.calPercent(buff.getBuff().getValue()[2]))));
		}
	}
}
