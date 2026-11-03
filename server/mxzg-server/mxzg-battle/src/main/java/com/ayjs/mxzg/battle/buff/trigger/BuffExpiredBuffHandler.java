package com.ayjs.mxzg.battle.buff.trigger;

import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.BuffDo;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.common.convert.ConvertUtils;
import com.ayjs.mxzg.config.struct.BuffType;
import org.springframework.stereotype.Component;

import java.util.List;

/**
 * buff过期时触发
 */
@Component
public class BuffExpiredBuffHandler extends AbstractArtTriggerBuffHandler {

	@Override
	public BuffType getType() {
		return BuffType.BT_BUFF_EXPIRED;
	}

	@Override
	public void trigger(BuffDo buff, HeroDo beTrigger, HeroDo target, BattleContext context) {
		List<Integer> buffIds = buff.getBuff().getValues();
		BuffDo expiredBuff = target.getBuffInfo().getLastExpiredBuff();
		if(expiredBuff == null || !buffIds.contains(expiredBuff.getBuff().getIdx())){
			return;
		}

		super.trigger(buff, beTrigger, target, context);
	}
}
