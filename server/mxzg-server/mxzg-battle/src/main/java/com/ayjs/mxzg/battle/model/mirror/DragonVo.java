package com.ayjs.mxzg.battle.model.mirror;

import com.ayjs.mxzg.battle.model.DragonInfo;
import com.ayjs.mxzg.battle.model.SkillDo;
import lombok.Getter;
import lombok.Setter;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Getter
@Setter
public class DragonVo {

	private int dragonId;

	/** 属性信息 */
	private Map<Integer, Long> attributes;

	/** 技能信息 */
	private List<DragonSkill> skills;

	public static DragonVo valueOf(DragonInfo dragonInfo){
		if(dragonInfo == null){
			return null;
		}

		DragonVo dragonVo = new DragonVo();
		dragonVo.setAttributes(dragonInfo.getAttributeInfo().getAttributeValues());
		List<DragonSkill> skills = new ArrayList<>();
		for(SkillDo skillDo : dragonInfo.getSkillInfo().getActiveSkills()){
			if(skillDo.getSkill() == null){
				DragonSkill skill = DragonSkill.valueOf(skillDo.getInitialRound(), 0, 0);
				skills.add(skill);
			} else {
				DragonSkill skill = DragonSkill.valueOf(skillDo.getInitialRound(), skillDo.getSkillId(), skillDo.getSkill().getLevel());
				skills.add(skill);
			}
		}

		dragonVo.setSkills(skills);
		dragonVo.setDragonId(dragonInfo.getDragonId());
		return dragonVo;
	}

}
