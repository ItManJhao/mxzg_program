/**
 * 
 */
package com.ayjs.mxzg.battle.buff.trigger;

import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.BuffDo;
import com.ayjs.mxzg.battle.model.DamageResult;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.battle.model.HitType;
import com.ayjs.mxzg.config.struct.BuffType;
import org.springframework.stereotype.Component;

import java.util.List;

/**
 * 控制时触发的buff
 */
@Component
public class ControllingBuffHandler extends AbstractArtTriggerBuffHandler {

	@Override
	public BuffType getType() {
		return BuffType.BT_CONTROLLING;
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
