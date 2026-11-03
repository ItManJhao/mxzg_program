package com.ayjs.mxzg.battle.buff.attribute;

import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.BuffDo;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.battle.util.AttributeUtil;
import com.ayjs.mxzg.common.util.EnumUtils;
import com.ayjs.mxzg.config.struct.AttributeType;
import com.ayjs.mxzg.config.struct.BuffType;
import com.ayjs.mxzg.protocol.BattleGMsg.BuffInfo.Builder;
import org.springframework.stereotype.Component;

/**
 * 根据自身百分比修改属性buff处理器
 * @author meiyc
 *
 */
@Component
public class AttributeProportionBuffHandler extends AbstractBaseAttributeBuffHandler {

	@Override
	public BuffType getType() {
		return BuffType.BT_ATTRIBUTE_PROPORTION;
	}
	
	@Override
	protected void handleEffect(BuffDo buffDo, HeroDo attacker, HeroDo target, Builder builder) {
		int attributeType = buffDo.getBuff().getValue()[0];
		int proportion = buffDo.getBuff().getValue()[1];
		AttributeType type = EnumUtils.getEnumByValue(AttributeType.class, attributeType);
		long attributeValue = attacker.getAttribute(type);
		attributeValue = AttributeUtil.addPercent(attributeValue, proportion);
		buffDo.setValue(attributeValue);
		target.getAttributeInfo().updateAttribute(type, attributeValue);
	}
	
	@Override
	public void removeBuff(BuffDo buff, HeroDo target, BattleContext context) {
		int attributeType = buff.getBuff().getValue()[0];
		long attributeValue = buff.getValue();
		AttributeType type = EnumUtils.getEnumByValue(AttributeType.class, attributeType);
		target.getAttributeInfo().updateAttribute(type, -attributeValue);
	}


}
