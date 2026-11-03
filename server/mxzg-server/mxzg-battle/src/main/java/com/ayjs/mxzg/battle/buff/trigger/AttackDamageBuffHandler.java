package com.ayjs.mxzg.battle.buff.trigger;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.config.struct.BuffType;

/**
 * 普通攻击造成伤害时触发
 * @author meiyc
 *
 */
@Component
public class AttackDamageBuffHandler extends AbstractArtTriggerBuffHandler {

	@Override
	public BuffType getType() {
		return BuffType.BT_ATTACK_SELF;
	}

}
