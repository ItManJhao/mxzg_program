package com.ayjs.mxzg.battle.buff.trigger;

import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.BuffDo;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.config.struct.BuffType;
import org.springframework.stereotype.Component;

import java.util.List;

/**
 * 被添加控制类debuff时触发
 * @author meiyc
 *
 */
@Component
public class ControlDebuffBuffHandler extends AbstractArtTriggerBuffHandler {

	@Override
	public BuffType getType() {
		return BuffType.BT_CONTROL_DEBUFF;
	}
	
	@Override
	public void trigger(BuffDo buff, HeroDo beTrigger, HeroDo target, BattleContext context) {
		List<Integer> buffTypes = buff.getBuff().getValues();
		BuffDo controlBuff = beTrigger.getLastControlBuff();
		if(buffTypes.contains(controlBuff.getBuff().getType().getValue())){
			super.trigger(buff, beTrigger, target, context);
		}
	}
	
}
