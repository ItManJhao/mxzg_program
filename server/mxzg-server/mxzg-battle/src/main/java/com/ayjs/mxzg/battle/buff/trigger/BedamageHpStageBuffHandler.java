package com.ayjs.mxzg.battle.buff.trigger;

import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.BuffDo;
import com.ayjs.mxzg.battle.model.DamageResult;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.battle.util.AttributeUtil;
import com.ayjs.mxzg.config.excel.entity.CBuff;
import com.ayjs.mxzg.config.struct.BuffType;
import org.springframework.stereotype.Component;

/**
 * 按照伤害百分比触发多少次buff
 * @author meiyc
 *
 */
@Component
public class BedamageHpStageBuffHandler extends AbstractArtTriggerBuffHandler {

	@Override
	public BuffType getType() {
		return BuffType.BT_BEDAMAGE_HP_STAGE;
	}
	
	@Override
	public void trigger(BuffDo buff, HeroDo beTrigger, HeroDo target, BattleContext context) {
		double rate = AttributeUtil.calPercent(buff.getBuff().getValue()[0]);
		DamageResult result = target.getResult();		
		long damage = Math.abs(result.getInitialDamage());
		long maxHp = beTrigger.getAttributeInfo().getMaxHp();
		double damageRage = damage * 1.0 / maxHp;
		int count = (int)(damageRage / rate);
		for(int i = 0; i < count ; i++){
			if(checkTriggerTimes(buff, beTrigger, context)){
				super.trigger(buff, beTrigger, target, context);
			}
		}
	}

	@Override
	protected int getTriggerTimes(CBuff buff) {
		return buff.getValue().length <= 1 ? 0 : buff.getValue()[1];
	}

	
}
