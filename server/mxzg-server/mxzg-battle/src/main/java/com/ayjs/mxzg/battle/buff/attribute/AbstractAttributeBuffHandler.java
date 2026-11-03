package com.ayjs.mxzg.battle.buff.attribute;

import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.BuffDo;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.common.util.EnumUtils;
import com.ayjs.mxzg.config.struct.AttributeType;
import com.ayjs.mxzg.protocol.BattleGMsg.BuffInfo.Builder;

/**
 * 抽象的属性修改buff处理器
 * @author meiyc
 *
 */
public abstract class AbstractAttributeBuffHandler extends AbstractBaseAttributeBuffHandler {


	@Override
	protected void handleEffect(BuffDo buffDo, HeroDo attacker, HeroDo target, Builder builder) {
		int attributeType = buffDo.getBuff().getValue()[0];
		int attributeValue = buffDo.getBuff().getValue()[1];
		AttributeType type = EnumUtils.getEnumByValue(AttributeType.class, attributeType);
		target.getAttributeInfo().updateAttribute(type, attributeValue);
	}
	
	@Override
	public void removeBuff(BuffDo buff, HeroDo target, BattleContext context) {
		int attributeType = buff.getBuff().getValue()[0];
		int attributeValue = buff.getBuff().getValue()[1];
		AttributeType type = EnumUtils.getEnumByValue(AttributeType.class, attributeType);
		target.getAttributeInfo().updateAttribute(type, -attributeValue);
	}
	
}
