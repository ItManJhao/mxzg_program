package com.ayjs.mxzg.battle.buff.persistent;

import com.ayjs.mxzg.battle.model.DamageResult;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.battle.util.AttributeUtil;
import com.ayjs.mxzg.config.excel.entity.CBuff;
import com.ayjs.mxzg.config.struct.AttributeType;
import com.ayjs.mxzg.config.struct.BuffType;
import org.springframework.stereotype.Component;

/**
 * 瘟疫buff，每回合损失自己的生命值上限，不超过一定比例的攻击
 * @author meiyc
 *
 */
@Component
public class PlagueBuffHandler extends AbstractPersistentBuffHandler {

	@Override
	public BuffType getType() {
		return BuffType.BT_PLAGUE;
	}

	@Override
	protected DamageResult calDamage(CBuff buff, HeroDo attacker, HeroDo target) {
		long hpRate = buff.getValue()[0];
		long maxHp = target.getAttributeInfo().getMaxHp();
		long damage = AttributeUtil.addPercent(maxHp, hpRate);
		long attackRate = buff.getValue()[1];
		long attack = attacker.getAttribute(AttributeType.ATTACK);
		long maxDamage = AttributeUtil.addPercent(attack, attackRate);
		damage = Math.min(damage, maxDamage);
		return DamageResult.builder().damage(damage).fixedAttack(true).build();
	}
}
