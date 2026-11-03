package com.ayjs.mxzg.battle.buff.trigger;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.config.struct.BuffType;

/**
 * 被技能攻击时触发
 * @author meiyc
 *
 */
@Component
public class BeattackSkillBuffHandler extends AbstractArtTriggerBuffHandler {

	@Override
	public BuffType getType() {
		return BuffType.BT_BEATTACK_SKILL;
	}

}
