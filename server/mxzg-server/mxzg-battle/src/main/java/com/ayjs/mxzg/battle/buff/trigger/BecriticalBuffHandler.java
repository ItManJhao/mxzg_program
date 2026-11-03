package com.ayjs.mxzg.battle.buff.trigger;

import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.BuffDo;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.config.excel.entity.CBuff;
import com.ayjs.mxzg.config.struct.BuffType;
import org.springframework.stereotype.Component;

/**
 * 被暴击时触发
 * @author meiyc
 *
 */
@Component
public class BecriticalBuffHandler extends AbstractArtTriggerBuffHandler {

	@Override
	public BuffType getType() {
		return BuffType.BT_BECRITICAL;
	}	

	@Override
	public void trigger(BuffDo buff, HeroDo beTrigger, HeroDo target, BattleContext context) {
		int targetType = buff.getBuff().getValue()[0];
		if(targetType == 1 && buff.getSourceId() != target.getUnitId()){
			return;
		}
		super.trigger(buff, beTrigger, target, context);
		checkTriggerTimes(buff, beTrigger, context);
	}
	
	@Override
	protected int getTriggerTimes(CBuff buff) {
		return buff.getValue().length < 2 ? 0 : buff.getValue()[1];
	}
}
