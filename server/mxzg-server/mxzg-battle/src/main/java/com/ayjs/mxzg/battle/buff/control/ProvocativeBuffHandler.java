package com.ayjs.mxzg.battle.buff.control;

import com.ayjs.mxzg.config.struct.BuffType;
import org.springframework.stereotype.Component;

/**
 * 挑衅，只能用普攻攻击buff施加者
 */
@Component
class ProvocativeBuffHandler extends  AbstractControlBuffHandler {

	@Override
	public BuffType getType() {
		return BuffType.BT_PROVOCATIVE;
	}
}
