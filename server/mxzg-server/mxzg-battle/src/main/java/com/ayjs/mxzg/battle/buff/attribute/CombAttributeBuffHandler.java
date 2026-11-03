package com.ayjs.mxzg.battle.buff.attribute;

import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.BuffDo;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.battle.util.AttributeUtil;
import com.ayjs.mxzg.config.struct.AttributeType;
import com.ayjs.mxzg.config.struct.BuffType;
import com.ayjs.mxzg.protocol.BattleGMsg.BuffInfo.Builder;
import org.springframework.stereotype.Component;

/**
 *  根据自己的属性修改目标的属性
 * @author meiyc
 *
 */
@Component
public class CombAttributeBuffHandler extends AbstractAttributeBuffHandler {

	@Override
	public BuffType getType() {
		return BuffType.BT_COMB_ATTRIBUTE;
	}

	@Override
	protected void handleEffect(BuffDo buffDo, HeroDo attacker, HeroDo target, Builder builder) {
		int attributeType = buffDo.getBuff().getValue()[0];
		int selfRate = buffDo.getBuff().getValue()[1];
		int targetRate = buffDo.getBuff().getValue()[2];
		AttributeType type = AttributeType.valueOf(attributeType);
        long selfValue = AttributeUtil.addPercent(attacker.getAttribute(type), selfRate);
        long targetValue = AttributeUtil.addPercent(target.getAttribute(type), targetRate);
		long value = selfValue + targetValue;
		target.getAttributeInfo().updateAttribute(type, value);
		buffDo.setValue(value);
	}


	@Override
	public void removeBuff(BuffDo buff, HeroDo target, BattleContext context) {
		int attributeType = buff.getBuff().getValue()[0];
		AttributeType type = AttributeType.valueOf(attributeType);
		target.getAttributeInfo().updateAttribute(type, -buff.getValue());
	}
}
