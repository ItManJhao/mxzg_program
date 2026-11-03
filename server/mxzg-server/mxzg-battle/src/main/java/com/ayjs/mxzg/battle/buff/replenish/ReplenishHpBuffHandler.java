package com.ayjs.mxzg.battle.buff.replenish;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.battle.util.AttributeUtil;
import com.ayjs.mxzg.config.excel.entity.CBuff;
import com.ayjs.mxzg.config.struct.AttributeType;
import com.ayjs.mxzg.config.struct.BuffType;

/**
 * 恢复自身攻击百分比的生命值
 * @author meiyc
 *
 */
@Component
public class ReplenishHpBuffHandler extends AbstractReplenishBuffHandler {

	@Override
	public BuffType getType() {
		return BuffType.BT_REPLENISH_HP;
	}

	@Override
	protected long replenish(CBuff buff, HeroDo attacker, HeroDo defender, BattleContext context) {
		long attackRate = buff.getValue()[0];
		long attack = attacker.getAttribute(AttributeType.ATTACK);
		return AttributeUtil.addPercent(attack, attackRate);
	}

}
