package com.ayjs.mxzg.battle.buff.replenish;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.battle.util.AttributeUtil;
import com.ayjs.mxzg.config.excel.entity.CBuff;
import com.ayjs.mxzg.config.struct.BuffType;

/**
 * 恢复最大生命值的百分比
 * @author meiyc
 *
 */
@Component
public class ReplenishHpMaximumBuffHandler extends AbstractReplenishBuffHandler {

	@Override
	public BuffType getType() {
		return BuffType.BT_REPLENISH_HP_MAXIMUM;
	}


	@Override
	protected long replenish(CBuff buff, HeroDo attacker, HeroDo defender, BattleContext context) {
		int maxHpRate = buff.getValue()[0];
		long maxHp = attacker.getAttributeInfo().getMaxHp();
		return AttributeUtil.addPercent(maxHp, maxHpRate);
	}

}
