/**
 * 
 */
package com.ayjs.mxzg.battle.buff.trigger;

import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.BuffDo;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.config.struct.BuffType;
import org.springframework.stereotype.Component;

import java.util.List;

/**
 * 破冰时触发
 */
@Component
public class BreakIceBuffHandler extends AbstractArtTriggerBuffHandler {

	@Override
	public BuffType getType() {
		return BuffType.BT_BREAK_ICE;
	}

	@Override
	public void trigger(BuffDo buff, HeroDo beTrigger, HeroDo target, BattleContext context) {
		BuffDo buffDo = target.getLastControlBuff();
		if(buffDo == null) {
			return;
		}

		List<Integer> buffType = buff.getBuff().getValues();
		if(buffType.contains(buffDo.getBuff().getType().getValue())){
			super.trigger(buff, beTrigger, target, context);
		}

	}

}
