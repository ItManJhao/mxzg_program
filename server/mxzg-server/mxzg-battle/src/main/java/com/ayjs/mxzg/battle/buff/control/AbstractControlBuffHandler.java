package com.ayjs.mxzg.battle.buff.control;

import com.ayjs.mxzg.battle.buff.AbstractBaseDamageBuffHandler;
import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.BuffDo;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.common.util.RandomUtils;
import com.ayjs.mxzg.config.excel.entity.CBuff;
import com.ayjs.mxzg.config.struct.AttributeType;
import com.ayjs.mxzg.config.struct.BuffType;
import com.ayjs.mxzg.protocol.BattleGMsg.BuffInfo.Builder;

/**
 * 抽象的控制类buff处理器
 * @author meiyc
 *
 */
public abstract class AbstractControlBuffHandler extends AbstractBaseDamageBuffHandler {

	@Override
	public void handle(CBuff buff, HeroDo attacker, HeroDo defender, BattleContext context, Builder builder) {
		if(defender.haveBuff(BuffType.BT_IMMUNITY_CONTROL)) {
			return;
		}
		double controlResistanceRate = defender.getRate(AttributeType.FREE_CONTROL_PERCENT);
		double controlAttchPercent = buff.getAttchPercent();
		double controlPercent = attacker.getRate(AttributeType.CONTROL_PERCENT);
		AttributeType resistanceAttribute = buff.getType().buffResistanceAttribute();
		double resistanceRate = resistanceAttribute == null ? 0 : defender.getRate(resistanceAttribute);
		controlAttchPercent = controlAttchPercent * (1 - resistanceRate) * (1 + controlPercent) * (1 - controlResistanceRate);
		if(!RandomUtils.isHit(controlAttchPercent)){
			builder.addResistances(AttributeType.FREE_CONTROL_PERCENT.getValue());
			return;
		}

		BuffDo buffDo = addBuff(buff, attacker, defender, builder, context);
		defender.setLastControlBuff(buffDo);
		battleTrigger.trigger(BuffType.BT_CONTROL_DEBUFF, defender, attacker, context);
		battleTrigger.trigger(BuffType.BT_CONTROLLING, attacker, defender, context);
	}

}
