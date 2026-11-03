package com.ayjs.mxzg.battle.buff.trigger;

import com.ayjs.mxzg.config.struct.BuffType;
import org.springframework.stereotype.Component;

/**
 * 使用魔法技能时触发
 * @author meiyc
 *
 */
@Component
public class UseMagicSkillBuffHandler extends AbstractArtTriggerBuffHandler {

	@Override
	public BuffType getType() {
		return BuffType.BT_USE_MAGIC_SKILL;
	}
	
}
