package com.ayjs.mxzg.battle.buff.replenish;

import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.DamageResult;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.battle.util.AttributeUtil;
import com.ayjs.mxzg.config.excel.entity.CBuff;
import com.ayjs.mxzg.config.struct.BuffType;
import org.springframework.stereotype.Component;

/**
 * 恢复伤害的百分比值
 * @author meiyc
 *
 */
@Component
public class ReplenishHpDamageBuffHandler extends AbstractReplenishBuffHandler {

	@Override
	public BuffType getType() {
		return BuffType.BT_REPLENISH_HP_DAMAGE;
	}

	@Override
	protected long replenish(CBuff buff, HeroDo attacker, HeroDo defender, BattleContext context) {
		DamageResult result = attacker.getResult();
		if(result == null || result.isMiss()){
			return 0;
		}

		if( attacker.getDamageType() != null && buff.getValue()[1] != 0 && attacker.getDamageType().getValue() != buff.getValue()[1]) {
			return 0;
		}
		long damageRate = buff.getValue()[0];
		return Math.abs(AttributeUtil.addPercent(result.getInitialDamage(), damageRate));
	}
}
