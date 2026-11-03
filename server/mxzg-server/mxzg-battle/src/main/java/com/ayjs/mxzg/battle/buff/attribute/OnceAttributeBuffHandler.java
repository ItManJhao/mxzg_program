package com.ayjs.mxzg.battle.buff.attribute;

import com.ayjs.mxzg.battle.model.BuffDo;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.common.util.EnumUtils;
import com.ayjs.mxzg.config.struct.AttributeType;
import com.ayjs.mxzg.config.struct.BuffType;
import com.ayjs.mxzg.protocol.BattleGMsg.BuffInfo.Builder;
import org.springframework.stereotype.Component;

/**
 * 一次性属性修改buff处理器
 * @author meiyc
 *
 */
@Component
public class OnceAttributeBuffHandler extends AbstractBaseAttributeBuffHandler {

	@Override
	public BuffType getType() {
		return BuffType.BT_ONCE_ATTRIBUTE;
	}
	
	@Override
	protected void handleEffect(BuffDo buffDo, HeroDo attacker, HeroDo target, Builder builder) {
		int attributeType = buffDo.getBuff().getValue()[0];
		int attributeValue = buffDo.getBuff().getValue()[1];
		AttributeType type = EnumUtils.getEnumByValue(AttributeType.class, attributeType);
		target.getAttributeInfo().addOnceAttribute(type, attributeValue);
	}

}
