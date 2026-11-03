package com.ayjs.mxzg.battle.buff.damage;

import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.DamageResult;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.battle.util.AttributeUtil;
import com.ayjs.mxzg.config.excel.entity.CBuff;
import com.ayjs.mxzg.config.struct.AttributeType;
import com.ayjs.mxzg.config.struct.BuffType;
import org.springframework.stereotype.Component;

/**
 * 真实伤害buff处理器，羁绊女神伤害专用，如果英雄使用该伤害类型必须关闭反击
 * @author meiyc
 *
 */
@Component
public class DamageRealBuffHandler extends AbstractDamageBuffHandler {
	
	@Override
	public BuffType getType() {
		return BuffType.BT_DAMAGE_REAL_ATTACH;
	}
	

	@Override
	protected DamageResult calDamage(CBuff buff, HeroDo attacker, HeroDo defender, BattleContext context) {
		int skillDamage = buff.getSkillDamageValue();
		long attack = attacker.getAttribute(AttributeType.ATTACK);
		long damage = AttributeUtil.addPercent(attack, skillDamage);
		damage = -damage;
		return DamageResult.createRealDamage(damage);
	}

}
