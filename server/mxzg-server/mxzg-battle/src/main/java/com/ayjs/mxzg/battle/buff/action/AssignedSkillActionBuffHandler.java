package com.ayjs.mxzg.battle.buff.action;

import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.battle.model.SkillDo;
import com.ayjs.mxzg.config.excel.cache.HeroSkillSysCache;
import com.ayjs.mxzg.config.excel.entity.CBuff;
import com.ayjs.mxzg.config.excel.entity.CHeroSkill;
import com.ayjs.mxzg.config.struct.BuffType;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

/**
 * 执行一次指定的技能攻击
 * @author meiyc
 *
 */
@Component
public class AssignedSkillActionBuffHandler extends AbstractActionBuffHandler {

	@Autowired
	private HeroSkillSysCache heroSkillSysCache;
	
	@Override
	public BuffType getType() {
		return BuffType.BT_ASSIGNED_SKILL_ACTION;
	}

	
	@Override
	protected SkillDo getSkill(CBuff buff, HeroDo attacker) {
		int skillId = buff.getValues().get(0);
		int skillLevel = buff.getValues().get(1);
		CHeroSkill heroSkill = heroSkillSysCache.getHeroSkillByOrThrow(skillId, skillLevel);
		return SkillDo.createOf(heroSkill);
	}

}
