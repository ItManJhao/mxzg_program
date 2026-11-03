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
 * 造成无视防御的攻击
 * @author meiyc
 *
 */
@Component
public class DamageIgnoreBuffHandler extends AbstractDamageBuffHandler {

	@Override
	public BuffType getType() {
		return BuffType.BT_DAMAGE_IGNORE;
	}

	@Override
	protected DamageResult calDamage(CBuff buff, HeroDo attacker, HeroDo defender, BattleContext context) {
		defender.getAttributeInfo().setOnceAttribute(AttributeType.DEFENSE, 0);
		return FightUtil.calDamage(buff, attacker, defender, false);
	}

}
