package com.ayjs.mxzg.battle.buff.function;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.ayjs.mxzg.battle.buff.BuffHandler;
import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.battle.model.SkillDo;
import com.ayjs.mxzg.config.excel.cache.HeroSkillSysCache;
import com.ayjs.mxzg.config.excel.entity.CBuff;
import com.ayjs.mxzg.config.excel.entity.CHeroSkill;
import com.ayjs.mxzg.config.struct.BuffType;
import com.ayjs.mxzg.protocol.BattleGMsg.BuffInfo.Builder;

/**
 * 替换英雄普通技能
 * @author meiyc
 *
 */
@Component
public class CommonChangeBuffHandler implements BuffHandler {

	@Autowired
	private HeroSkillSysCache heroSkillSysCache;
	
	@Override
	public BuffType getType() {
		return BuffType.BT_COMMON_CHANGE;
	}

	@Override
	public void handle(CBuff buff, HeroDo attacker, HeroDo defender, BattleContext context, Builder builder) {
		int newSkillId = buff.getValue()[0];
		SkillDo oldSkill = attacker.getCurrentSkill();
		CHeroSkill heroSkill = heroSkillSysCache.getHeroSkillByOrThrow(newSkillId, oldSkill.getSkill().getLevel());
		attacker.getSkillInfo().setGeneralAttack(SkillDo.createOf(heroSkill));;
	}
}
