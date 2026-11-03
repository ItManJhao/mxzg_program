package com.ayjs.mxzg.battle.buff.action;

import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.battle.model.SkillDo;
import com.ayjs.mxzg.config.excel.entity.CBuff;
import com.ayjs.mxzg.config.struct.BuffType;
import org.springframework.stereotype.Component;

/**
 * 执行一次普通攻击
 * @author meiyc
 *
 */
@Component
public class AttackActionBuffHandler extends AbstractActionBuffHandler {

	@Override
	public BuffType getType() {
		return BuffType.BT_ATTACK_ACTION;
	}


	@Override
	protected SkillDo getSkill(CBuff buff, HeroDo attacker) {
		return attacker.getSkillInfo().getGeneralAttack();
	}
	
}
