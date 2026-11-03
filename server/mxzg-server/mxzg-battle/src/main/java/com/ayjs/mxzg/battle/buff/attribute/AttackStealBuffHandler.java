package com.ayjs.mxzg.battle.buff.attribute;

import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.BuffDo;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.battle.util.AttributeUtil;
import com.ayjs.mxzg.config.struct.AttributeType;
import com.ayjs.mxzg.config.struct.BuffType;
import com.ayjs.mxzg.protocol.BattleGMsg.BuffInfo.Builder;
import org.springframework.stereotype.Component;

import java.util.Objects;

/**
 * 攻击偷取
 * @author meiyc
 *
 */
@Component
public class AttackStealBuffHandler extends AbstractBaseAttributeBuffHandler {

	@Override
	public BuffType getType() {
		return BuffType.BT_ATTACK_STEAL;
	}
	

	@Override
	protected void handleEffect(BuffDo buffDo, HeroDo attacker, HeroDo target, Builder builder) {
		int stealValue = buffDo.getBuff().getValue()[0];
		long attack = target.getAttribute(AttributeType.ATTACK);
		
		target.getAttributeInfo().updateAttribute(AttributeType.ATTACK_PERCENT, -stealValue);
		long stealAttack = AttributeUtil.addPercent(attack, stealValue);
		attacker.getAttributeInfo().updateAttribute(AttributeType.ATTACK, stealAttack);
		buffDo.setValue(stealAttack);
	}

	
	@Override
	public void removeBuff(BuffDo buffDo, HeroDo target, BattleContext context) {
		int stealValue = buffDo.getBuff().getValue()[0];
		target.getAttributeInfo().updateAttribute(AttributeType.ATTACK_PERCENT, stealValue);
		
		HeroDo attacker = context.getHero(buffDo.getSourceId());
		if (Objects.nonNull(attacker)){
			attacker.getAttributeInfo().updateAttribute(AttributeType.ATTACK, -buffDo.getValue());
		}
	}
}
