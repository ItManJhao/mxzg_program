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
 * 被攻击时生命低于百分比时触发
 * @author meiyc
 *
 */
@Component
public class BedamageHpMaxmumBuffHandler extends AbstractArtTriggerBuffHandler {

	
	@Override
	public BuffType getType() {
		return BuffType.BT_BEDAMAGE_HP_MAXIMUM;
	}

	@Override
	public void trigger(BuffDo buff, HeroDo beTrigger, HeroDo target, BattleContext context) {
		DamageResult result = target.getResult();
		double triggerRate = AttributeUtil.calPercent(buff.getBuff().getValue()[0]);
		long currentHp = beTrigger.getHp();
		if(currentHp <= 0){
			return;
		}
		long maxHp = beTrigger.getAttributeInfo().getMaxHp();
		double currentRate = beTrigger.getHpRate();
		double beforeHpRate = (currentHp - result.getDamage()) * 1.0 / maxHp;
		if(beforeHpRate >= triggerRate && currentRate < triggerRate){
			super.trigger(buff, beTrigger, target, context);
			checkTriggerTimes(buff, beTrigger, context);
		}
	}
	
	@Override
	protected int getTriggerTimes(CBuff buff) {
		return buff.getValue().length <= 1 ? 0 : buff.getValue()[1];
	}

}
