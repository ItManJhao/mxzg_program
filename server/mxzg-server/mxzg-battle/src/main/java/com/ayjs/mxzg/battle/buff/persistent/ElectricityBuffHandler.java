package com.ayjs.mxzg.battle.buff.persistent;

import com.ayjs.mxzg.battle.buff.AbstractDebuffHandler;
import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.BuffDo;
import com.ayjs.mxzg.battle.model.DamageResult;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.battle.model.HitType;
import com.ayjs.mxzg.battle.util.AttributeUtil;
import com.ayjs.mxzg.config.struct.AttributeType;
import com.ayjs.mxzg.config.struct.BuffType;
import org.springframework.stereotype.Component;

/**
 * 感电buff
 * @author meiyc
 *
 */
@Component
public class ElectricityBuffHandler extends AbstractDebuffHandler {

	@Override
	public BuffType getType() {
		return BuffType.BT_ELECTRICITY;
	}

	@Override
	public void trigger(BuffDo buff, HeroDo beTrigger, HeroDo target, BattleContext context) {
		int attackRatio = buff.getBuff().getValue()[0];
		int buffId = buff.getBuff().getValue()[1];
		buffId = buffId == 0 ? target.getResult().getBuffId() : buffId;
		HeroDo source = context.getHero(buff.getSourceId());
		long attack = source.getAttribute(AttributeType.ATTACK);
		long damage = AttributeUtil.addPercent(attack, attackRatio);
		DamageResult result = DamageResult.builder().damage(-damage).buffId(buffId).fixedAttack(true).hitType(HitType.HIT).build();
		addDamageBuff(buff.getBuff(), result, source, beTrigger,  context);
	}
}
