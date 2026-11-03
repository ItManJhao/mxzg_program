package com.ayjs.mxzg.battle.buff.control;

import com.ayjs.mxzg.config.struct.BuffType;
import org.springframework.stereotype.Component;

/**
 * 封魂，被封魂的玩家不能被复活
 */
@Component
class SealSoulBuffHandler extends  AbstractControlBuffHandler {

	@Override
	public BuffType getType() {
		return BuffType.BT_SEAL_SOUL;
	}
}
