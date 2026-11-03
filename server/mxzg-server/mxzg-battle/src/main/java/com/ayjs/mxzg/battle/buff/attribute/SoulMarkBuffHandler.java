package com.ayjs.mxzg.battle.buff.attribute;

import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.BuffDo;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.config.struct.AttributeType;
import com.ayjs.mxzg.config.struct.BuffType;
import com.ayjs.mxzg.protocol.BattleGMsg.BuffInfo.Builder;
import org.springframework.stereotype.Component;

/**
 * 灵魂印记
 * @author meiyc
 *
 */
@Component
public class SoulMarkBuffHandler extends AbstractBaseAttributeBuffHandler {

	@Override
	public BuffType getType() {
		return BuffType.BT_SOUL_MARK;
	}

	@Override
	protected void handleEffect(BuffDo buffDo, HeroDo attacker, HeroDo target, Builder builder) {
		int reducePercent = buffDo.getBuff().getValue()[0];
		int treatmentRatio = buffDo.getBuff().getValue()[1];
		int antiControlRatio = buffDo.getBuff().getValue()[2];

		target.getAttributeInfo().updateAttribute(AttributeType.FINAL_DAMAGE_REDUCE_PERCENT, reducePercent);
		target.getAttributeInfo().updateAttribute(AttributeType.TREATMENT_PERCENT, treatmentRatio);
		target.getAttributeInfo().updateAttribute(AttributeType.FREE_CONTROL_PERCENT, antiControlRatio);
	}

	@Override
	public void removeBuff(BuffDo buff, HeroDo target, BattleContext context) {
		int reducePercent = buff.getBuff().getValue()[0];
		int treatmentRatio = buff.getBuff().getValue()[1];
		int antiControlRatio = buff.getBuff().getValue()[2];

		target.getAttributeInfo().updateAttribute(AttributeType.FINAL_DAMAGE_REDUCE_PERCENT, -reducePercent);
		target.getAttributeInfo().updateAttribute(AttributeType.TREATMENT_PERCENT, -treatmentRatio);
		target.getAttributeInfo().updateAttribute(AttributeType.FREE_CONTROL_PERCENT, -antiControlRatio);
	}

}
