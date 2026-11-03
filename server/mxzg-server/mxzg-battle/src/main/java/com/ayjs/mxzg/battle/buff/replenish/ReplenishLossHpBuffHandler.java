package com.ayjs.mxzg.battle.buff.replenish;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.battle.util.AttributeUtil;
import com.ayjs.mxzg.config.excel.entity.CBuff;
import com.ayjs.mxzg.config.struct.BuffType;

/**
 * 恢复已损失生命值的百分比
 * @author meiyc
 *
 */
@Component
public class ReplenishLossHpBuffHandler extends AbstractReplenishBuffHandler {

	@Override
	public BuffType getType() {
		return BuffType.BT_REPLENISH_LOSS_HP;
	}

	@Override
	protected long replenish(CBuff buff, HeroDo attacker, HeroDo defender, BattleContext context) {
		long replenishRateValue = buff.getValue()[0];
		double replenishRate = AttributeUtil.calPercent(replenishRateValue);
		
		long maxHp = attacker.getAttributeInfo().getMaxHp();
		long currentHp = attacker.getHp();
		long replenishHp = (long)((maxHp - currentHp) * replenishRate);
		
		return replenishHp;
	}

}
