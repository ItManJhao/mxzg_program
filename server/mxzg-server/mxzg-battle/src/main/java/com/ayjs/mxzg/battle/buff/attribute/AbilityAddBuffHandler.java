package com.ayjs.mxzg.battle.buff.attribute;

import com.ayjs.mxzg.config.struct.BuffType;
import org.springframework.stereotype.Component;

/**
 * 属性修改buff处理器
 * @author meiyc
 *
 */
@Component
public class AbilityAddBuffHandler extends AbstractAttributeBuffHandler {

	@Override
	public BuffType getType() {
		return BuffType.BT_ABILITY_ADD;
	}
	

}
