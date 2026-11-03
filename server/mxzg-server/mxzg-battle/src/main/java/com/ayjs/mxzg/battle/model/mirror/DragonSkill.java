package com.ayjs.mxzg.battle.model.mirror;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class DragonSkill {

	/**
	 * 初始回合
	 */
	private int initialRound;

	/**
	 * 技能id
	 */
	private int skillId;

	/**
	 * 技能等级
	 */
	private int skillLevel;


	public static DragonSkill valueOf(int initialRound, int skillId, int skillLevel){
		DragonSkill skill = new DragonSkill();
		skill.setInitialRound(initialRound);
		skill.setSkillId(skillId);
		skill.setSkillLevel(skillLevel);
		return skill;
	}

}
