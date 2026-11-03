package com.ayjs.mxzg.battle.buff.condition;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.config.excel.entity.CBuff;
import com.ayjs.mxzg.config.struct.BuffType;
import com.ayjs.mxzg.protocol.BattleGMsg.BuffInfo.Builder;

/**
 * buff使用次数限制，针对自己
 * @author meiyc
 *
 */
@Component
public class UseLimitBuffHandler extends AbstractConditionBuffHandler {

	@Override
	public BuffType getType() {
		return BuffType.BT_USE_LIMIT;
	}
	
	@Override
	public void handle(CBuff buff, HeroDo attacker, HeroDo defender, BattleContext context, Builder builder) {
		if(!checkCondition(buff, attacker, defender, context)){
			attacker.interrupt(attacker.getUnitId());
		}
	}
	
	@Override
	protected boolean checkCondition(CBuff buff, HeroDo attacker, HeroDo defender, BattleContext battleContextr) {
		int maxTriggerTimes = buff.getValue()[0];
		return attacker.triggerBuff(buff.getIdx(), maxTriggerTimes);
	}

}
