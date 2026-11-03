package com.ayjs.mxzg.battle.buff.trigger;

import com.ayjs.mxzg.config.struct.BuffType;
import org.springframework.stereotype.Component;

/**
 * 使用物理技能时触发
 * @author meiyc
 *
 */
@Component
public class UsePhysicalSkillBuffHandler extends AbstractArtTriggerBuffHandler {

	@Override
	public BuffType getType() {
		return BuffType.BT_USE_PHYSICAL_SKILL;
	}
	
}
