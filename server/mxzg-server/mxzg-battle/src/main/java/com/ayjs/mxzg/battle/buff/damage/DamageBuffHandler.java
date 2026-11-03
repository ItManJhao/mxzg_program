package com.ayjs.mxzg.battle.buff.damage;

import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.DamageResult;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.battle.util.FightUtil;
import com.ayjs.mxzg.config.excel.entity.CBuff;
import com.ayjs.mxzg.config.struct.BuffType;
import org.springframework.stereotype.Component;

/**
 * 基于自身攻击的伤害buff处理器
 * @author meiyc
 *
 */
@Component
public class DamageBuffHandler extends AbstractDamageBuffHandler {

	@Override
	public BuffType getType() {
		return BuffType.BT_DAMAGE;
	}

	@Override
	protected DamageResult calDamage(CBuff buff, HeroDo attacker, HeroDo defender, BattleContext context) {
		return FightUtil.calDamage(buff, attacker, defender, false);
	}

}
