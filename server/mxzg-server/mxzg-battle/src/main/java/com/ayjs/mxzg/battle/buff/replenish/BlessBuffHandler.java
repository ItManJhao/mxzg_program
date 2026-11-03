package com.ayjs.mxzg.battle.buff.replenish;

import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.battle.util.AttributeUtil;
import com.ayjs.mxzg.config.excel.entity.CBuff;
import com.ayjs.mxzg.config.struct.BuffType;
import org.springframework.stereotype.Component;

/**
 * 天佑，根据自己和目标生命值上限恢复指定比例的生命值
 * @author meiyc
 *
 */
@Component
public class BlessBuffHandler extends AbstractReplenishBuffHandler {

	@Override
	public BuffType getType() {
		return BuffType.BT_BLESS;
	}

	@Override
	protected long replenish(CBuff buff, HeroDo attacker, HeroDo defender, BattleContext context) {
		long attackRate = buff.getValue()[0];
		long targetRate = buff.getValue()[1];
		long attackHpLimit = attacker.getAttributeInfo().getMaxHp();
		long targetHpLimit = defender.getAttributeInfo().getMaxHp();
		return AttributeUtil.addPercent(attackHpLimit, attackRate) + AttributeUtil.addPercent(targetHpLimit, targetRate);
	}

}
