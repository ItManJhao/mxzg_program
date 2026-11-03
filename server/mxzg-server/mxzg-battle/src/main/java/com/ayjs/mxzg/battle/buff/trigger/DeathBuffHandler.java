package com.ayjs.mxzg.battle.buff.trigger;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.config.struct.BuffType;

/**
 * 死亡时触发
 * @author meiyc
 *
 */
@Component
public class DeathBuffHandler extends AbstractArtTriggerBuffHandler {

	@Override
	public BuffType getType() {
		return BuffType.BT_DEATH;
	}
	
}
