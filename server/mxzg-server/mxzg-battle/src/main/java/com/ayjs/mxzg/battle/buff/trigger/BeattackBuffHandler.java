package com.ayjs.mxzg.battle.buff.trigger;

import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.BuffDo;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.common.convert.ConvertUtils;
import org.springframework.stereotype.Component;

import com.ayjs.mxzg.config.struct.BuffType;

/**
 * 被攻击时触发
 * @author meiyc
 *
 */
@Component
public class BeattackBuffHandler extends AbstractArtTriggerBuffHandler {

	@Override
	public BuffType getType() {
		return BuffType.BT_BEATTACK;
	}

	@Override
	public void trigger(BuffDo buff, HeroDo beTrigger, HeroDo target, BattleContext context) {
		int typeValue = buff.getBuff().getValue()[0];
		BuffType buffType = typeValue == 0 ? null : ConvertUtils.toEnum(typeValue, BuffType.class);
		if(buffType == null || !beTrigger.getBuffsBy(buffType).isEmpty()){
			super.trigger(buff, beTrigger, target, context);
		}
	}
}
