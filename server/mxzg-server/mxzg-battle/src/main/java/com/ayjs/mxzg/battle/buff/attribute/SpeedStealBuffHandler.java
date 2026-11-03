package com.ayjs.mxzg.battle.buff.attribute;

import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.BuffDo;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.config.struct.AttributeType;
import com.ayjs.mxzg.config.struct.BuffType;
import com.ayjs.mxzg.protocol.BattleGMsg.BuffInfo.Builder;
import org.springframework.stereotype.Component;

/**
 * 速度偷取
 * @author meiyc
 *
 */
@Component
public class SpeedStealBuffHandler extends AbstractBaseAttributeBuffHandler {

	@Override
	public BuffType getType() {
		return BuffType.BT_SPEED_STEAL;
	}
	

	@Override
	protected void handleEffect(BuffDo buffDo, HeroDo attacker, HeroDo target, Builder builder) {
		int stealValue = buffDo.getBuff().getValue()[0];
		attacker.getAttributeInfo().updateAttribute(AttributeType.SPEED_PERCENT, stealValue);
		target.getAttributeInfo().updateAttribute(AttributeType.SPEED_PERCENT, -stealValue);
	}

	
	@Override
	public void removeBuff(BuffDo buffDo, HeroDo target, BattleContext context) {
		int stealValue = buffDo.getBuff().getValue()[0];
		HeroDo source = context.getHero(buffDo.getSourceId());
		source.getAttributeInfo().updateAttribute(AttributeType.SPEED_PERCENT, -stealValue);
		target.getAttributeInfo().updateAttribute(AttributeType.SPEED_PERCENT, stealValue);
	}
}
