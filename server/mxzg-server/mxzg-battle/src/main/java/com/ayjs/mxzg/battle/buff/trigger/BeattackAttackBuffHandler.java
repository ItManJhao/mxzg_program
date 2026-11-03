package com.ayjs.mxzg.battle.buff.trigger;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.config.struct.BuffType;

/**
 * 被普通攻击时触发
 * @author meiyc
 *
 */
@Component
public class BeattackAttackBuffHandler extends AbstractArtTriggerBuffHandler {

	@Override
	public BuffType getType() {
		return BuffType.BT_BEATTACK_ATTACK;
	}

}
