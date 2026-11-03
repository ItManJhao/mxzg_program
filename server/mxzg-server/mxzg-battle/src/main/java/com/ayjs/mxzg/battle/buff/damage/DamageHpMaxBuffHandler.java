package com.ayjs.mxzg.battle.buff.damage;

import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.DamageResult;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.battle.model.HitType;
import com.ayjs.mxzg.battle.util.AttributeUtil;
import com.ayjs.mxzg.config.excel.entity.CBuff;
import com.ayjs.mxzg.config.struct.AttributeType;
import com.ayjs.mxzg.config.struct.BuffType;
import org.springframework.stereotype.Component;

/**
 * 造成目标最大血量的伤害buff处理器
 * @author meiyc
 *
 */
@Component
public class DamageHpMaxBuffHandler extends AbstractDamageBuffHandler {

	@Override
	public BuffType getType() {
		return BuffType.BT_DAMAGE_HP_MAX;
	}

	@Override
	protected DamageResult calDamage(CBuff buff, HeroDo attacker, HeroDo defender, BattleContext context) {
		long rate = buff.getValue()[0];
		long attackMaxMultiple = buff.getValue()[2];
		long maxHp = defender.getAttributeInfo().getMaxHp();
		long damage = AttributeUtil.addPercent(maxHp, rate);
		long attackValue = attacker.getAttribute(AttributeType.ATTACK);
		long attackHp = AttributeUtil.addPercent(attackValue, attackMaxMultiple);
		if(damage > attackHp){
			damage = attackHp;
		}
		
		return DamageResult.builder().damage(-damage).hitType(HitType.HIT).build();
	}

}
