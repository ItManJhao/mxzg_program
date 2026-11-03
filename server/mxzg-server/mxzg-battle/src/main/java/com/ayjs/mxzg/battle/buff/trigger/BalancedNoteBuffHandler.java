/**
 * 
 */
package com.ayjs.mxzg.battle.buff.trigger;

import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.BuffDo;
import com.ayjs.mxzg.battle.model.DamageResult;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.battle.util.AttributeUtil;
import com.ayjs.mxzg.config.struct.BuffType;
import org.springframework.stereotype.Component;

/**
 * 均衡音符，格挡和反弹一定比例的伤害，不能格挡buff和斩杀伤害
 */
@Component
public class BalancedNoteBuffHandler extends AbstractArtTriggerBuffHandler {


	@Override
	public BuffType getType() {
		return BuffType.BT_BALANCED_NOTE;
	}

	@Override
	public void trigger(BuffDo buff, HeroDo beTrigger, HeroDo target, BattleContext context) {
		DamageResult damageResult = target.getResult();
		if(damageResult.isFixedAttack()){
			return;
		}

		int reduceRate = buff.getBuff().getValue()[0];
		long reduceDamage = AttributeUtil.addPercent(damageResult.getDamage(), reduceRate);
		damageResult.updateDamage(-reduceDamage);

		int bounceRate = buff.getBuff().getValue()[1];
		long bounceDamage = AttributeUtil.addPercent(damageResult.getDamage(), bounceRate);

		DamageResult bounceDamageResult = DamageResult.createRealDamage(bounceDamage);
		addDamageBuff(buff.getBuff(), bounceDamageResult, beTrigger, target, context);
	}

}
