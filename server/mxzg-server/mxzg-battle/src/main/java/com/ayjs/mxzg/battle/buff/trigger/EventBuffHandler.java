package com.ayjs.mxzg.battle.buff.trigger;

import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.BuffDo;
import com.ayjs.mxzg.battle.model.FightEventType;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.common.convert.ConvertUtils;
import com.ayjs.mxzg.config.struct.BuffType;
import org.springframework.stereotype.Component;

/**
 * 发生指定的事件时触发
 * @author meiyc
 *
 */
@Component
public class EventBuffHandler extends AbstractArtTriggerBuffHandler {

	@Override
	public BuffType getType() {
		return BuffType.BT_EVENT;
	}

	@Override
	public void trigger(BuffDo buff, HeroDo beTrigger, HeroDo target, BattleContext context) {
		int eventTypeValue = buff.getBuff().getValue()[0];
		int triggerTimes = buff.getBuff().getValue()[1];
		FightEventType eventType = ConvertUtils.toEnum(eventTypeValue, FightEventType.class);
		int times = beTrigger.getEventDo().getEventTimes(eventType);
		if(times >= triggerTimes){
			beTrigger.getEventDo().clean(eventType);
			super.trigger(buff, beTrigger, target, context);
		}
	}
}
