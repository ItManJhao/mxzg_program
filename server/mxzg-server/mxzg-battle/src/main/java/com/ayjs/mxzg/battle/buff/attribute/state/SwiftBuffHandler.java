package com.ayjs.mxzg.battle.buff.attribute.state;

import com.ayjs.mxzg.config.struct.BuffType;
import org.springframework.stereotype.Component;

/**
 * 属性修改buff处理器
 * @author meiyc
 *
 */
@Component
public class SwiftBuffHandler extends AbstractStateAttributeBuffHandler {

	@Override
	public BuffType getType() {
		return BuffType.BT_SWIFT;
	}

}
