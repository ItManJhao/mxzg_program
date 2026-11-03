package com.ayjs.mxzg.battle.buff.trigger;

import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.BuffDo;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.config.struct.BuffType;
import org.springframework.stereotype.Component;

/**
 * 使用技能时
 * @author meiyc
 *
 */
@Component
public class UseSkillBuffHandler extends AbstractArtTriggerBuffHandler {

	@Override
	public BuffType getType() {
		return BuffType.BT_USE_SKILL;
	}

	@Override
	protected boolean checkCondition(BuffDo buff, HeroDo beTrigger, HeroDo target, BattleContext context) {
		int skillId = buff.getBuff().getValue()[0];
		return skillId == 0 || beTrigger.getCurrentSkill().getSkill().getType() == skillId;
	}
}
