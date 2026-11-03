package com.ayjs.mxzg.battle.buff.function;

import com.ayjs.mxzg.battle.buff.trigger.AbstractArtTriggerBuffHandler;
import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.BuffDo;
import com.ayjs.mxzg.battle.model.DamageResult;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.battle.util.AttributeUtil;
import com.ayjs.mxzg.config.struct.BuffType;
import org.springframework.stereotype.Component;

import java.util.List;

/**
 * //庇护，伤害转移
 * @author meiyc
 *
 */
@Component
public class ShelterBuffHandler extends AbstractArtTriggerBuffHandler {

	@Override
	public BuffType getType() {
		return BuffType.BT_SHELTER;
	}

	@Override
	public void trigger(BuffDo buff, HeroDo beTrigger, HeroDo target, BattleContext context) {
		HeroDo source = context.getHero(buff.getSourceId());
		if(source.isDead()){return;	}

		long convertRatio = buff.getBuff().getValue()[0];
		DamageResult result = target.getResult();
		long damage = AttributeUtil.addPercent(Math.abs(result.getDamage()), convertRatio);
		result.updateDamage(damage);
		DamageResult convertDamage = DamageResult.builder().damage(-damage).buffId(result.getBuffId()).fixedAttack(true).build();
		addDamageBuff(buff.getBuff(), convertDamage, target, source, context);
	}
}
