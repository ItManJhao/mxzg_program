package com.ayjs.mxzg.battle.buff.replenish;

import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.BuffDo;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.battle.util.AttributeUtil;
import com.ayjs.mxzg.config.excel.cache.BuffSysCache;
import com.ayjs.mxzg.config.excel.entity.CBuff;
import com.ayjs.mxzg.config.struct.AttributeType;
import com.ayjs.mxzg.config.struct.BuffType;
import com.ayjs.mxzg.protocol.BattleGMsg.BuffInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

/**
 * 治疗溢出量转换为护盾
 * @author meiyc
 *
 */
@Component
public class TreatmentOverFlowBuffHandler extends AbstractReplenishBuffHandler {

	@Autowired
	private BuffSysCache buffSysCache;

	@Override
	public BuffType getType() {
		return BuffType.BT_TREATMENT_OVERFLOW_SHIELD;
	}


	@Override
	protected long replenish(CBuff buff, HeroDo attacker, HeroDo defender, BattleContext context) {
		long attackRate = buff.getValue()[0];
		long replenishHp;
		if(attackRate != 0){
			long attack = attacker.getAttribute(AttributeType.ATTACK);
			replenishHp = AttributeUtil.addPercent(attack, attackRate);
		} else {
			long hpRate = buff.getValue()[2];
			replenishHp =  AttributeUtil.addPercent(attacker.getAttributeInfo().getMaxHp(), hpRate);
		}

		long lossHp = defender.getAttributeInfo().getMaxHp() - defender.getHp();
		long shield = replenishHp > lossHp ? replenishHp - lossHp : 0;
		if(shield > 0){
			int buffId = buff.getValue()[1];
			CBuff cbuff = buffSysCache.getOrThrow(buffId);
			BuffInfo.Builder builder = BuffInfo.newBuilder();
			BuffDo buffDo = addBuff(cbuff, attacker, defender, builder, context);
			buffDo.setValue(shield);
			if(builder.isInitialized()){
				context.addEffectInfoBy(builder.build());
			}
		}

		return replenishHp - shield;
	}

}
