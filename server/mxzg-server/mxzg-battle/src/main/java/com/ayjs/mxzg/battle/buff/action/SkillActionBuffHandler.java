package com.ayjs.mxzg.battle.buff.action;

import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.battle.model.SkillDo;
import com.ayjs.mxzg.config.excel.entity.CBuff;
import com.ayjs.mxzg.config.struct.BuffType;

/**
 * 执行一次技能攻击
 * @author meiyc
 *
 */
public class SkillActionBuffHandler extends AbstractActionBuffHandler {

	
	@Override
	public BuffType getType() {
		return BuffType.BT_SKILL_ACTION;
	}

	
	@Override
	protected SkillDo getSkill(CBuff buff, HeroDo attacker) {
		return attacker.getSkillInfo().getActiveSkills().get(0);
	}

}
