package com.ayjs.mxzg.battle.buff.damage;

import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.DamageResult;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.battle.util.AttributeUtil;
import com.ayjs.mxzg.battle.util.FightUtil;
import com.ayjs.mxzg.config.excel.entity.CBuff;
import com.ayjs.mxzg.config.struct.BuffType;
import org.springframework.stereotype.Component;

/**
 * 根据debuff的层数来加成伤害
 * @author meiyc
 *
 */
@Component
public class DebuffDamageBuffHandler extends AbstractDamageBuffHandler {

	@Override
	public BuffType getType() {
		return BuffType.BT_DEBUFF_DAMAGE;
	}

	@Override
	protected DamageResult calDamage(CBuff buff, HeroDo attacker, HeroDo defender, BattleContext context) {
		int damageAdd = buff.getValue()[2];
		int maxAttackRate = buff.getValue()[3];
		DamageResult result = FightUtil.calDamage(buff, attacker, defender, false);
		int debuffNum = defender.getDeBuffs().size();

		long damage = Math.abs(result.getDamage());
		damage += AttributeUtil.addPercent(damage, damageAdd * debuffNum);

		long attack = attacker.getAttributeInfo().getAttack();
		long maxDamage = AttributeUtil.addPercent(attack, maxAttackRate);
		damage = Math.min(damage, maxDamage);

		return DamageResult.builder().fixedAttack(false).block(result.isBlock()).damage(-damage).hitType(result.getHitType()).build();
	}

}
