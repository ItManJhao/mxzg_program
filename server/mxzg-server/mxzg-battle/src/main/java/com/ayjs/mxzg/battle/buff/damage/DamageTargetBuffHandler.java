package com.ayjs.mxzg.battle.buff.damage;

import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.DamageResult;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.battle.util.FightUtil;
import com.ayjs.mxzg.config.excel.entity.CBuff;
import com.ayjs.mxzg.config.struct.AttributeType;
import com.ayjs.mxzg.config.struct.BuffType;
import org.springframework.stereotype.Component;

/**
 * 拿目标攻击力作为本次攻击计算伤害
 * @author meiyc
 *
 */
@Component
public class DamageTargetBuffHandler extends AbstractDamageBuffHandler {

	@Override
	public BuffType getType() {
		return BuffType.BT_DAMAGE_TARGET;
	}

	@Override
	protected DamageResult calDamage(CBuff buff, HeroDo attacker, HeroDo defender, BattleContext context) {
		long targetAttack = defender.getAttribute(AttributeType.ATTACK);
		attacker.getAttributeInfo().setOnceAttribute(AttributeType.ATTACK, targetAttack);
		return FightUtil.calDamage(buff, attacker, defender, false);
	}

}
