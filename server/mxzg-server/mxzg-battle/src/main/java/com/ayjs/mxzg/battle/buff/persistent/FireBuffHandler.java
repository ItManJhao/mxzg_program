package com.ayjs.mxzg.battle.buff.persistent;

import com.ayjs.mxzg.battle.model.DamageResult;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.battle.util.AttributeUtil;
import com.ayjs.mxzg.config.excel.entity.CBuff;
import com.ayjs.mxzg.config.struct.BuffType;
import org.springframework.stereotype.Component;

/**
 * 烈火buff，每回合燃烧生命值上限
 * @author meiyc
 *
 */
@Component
public class FireBuffHandler extends AbstractPersistentBuffHandler {

	@Override
	public BuffType getType() {
		return BuffType.BT_FIRE;
	}

	@Override
	protected DamageResult calDamage(CBuff buff, HeroDo attacker, HeroDo target) {
		long hpRate = buff.getValue()[0];
		long maxHp = attacker.getAttributeInfo().getMaxHp();
		long damage = AttributeUtil.addPercent(maxHp, hpRate);
		return DamageResult.builder().damage(-damage).fixedAttack(true).build();
	}
}
