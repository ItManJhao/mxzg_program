package com.ayjs.mxzg.battle.buff.persistent;

import com.ayjs.mxzg.battle.buff.AbstractDebuffHandler;
import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.BuffDo;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.config.excel.entity.CBuff;
import com.ayjs.mxzg.config.struct.AttributeType;
import com.ayjs.mxzg.config.struct.BuffType;
import com.ayjs.mxzg.protocol.BattleGMsg;
import org.springframework.stereotype.Component;

/**
 * 减速buff
 * @author meiyc
 *
 */
@Component
public class FrostBuffHandler extends AbstractDebuffHandler {

	@Override
	public BuffType getType() {
		return BuffType.BT_FROST;
	}

	@Override
	public void handle(CBuff buff, HeroDo attacker, HeroDo defender, BattleContext context, BattleGMsg.BuffInfo.Builder builder) {
		super.handle(buff, attacker, defender, context, builder);
		if(builder.isInitialized()){
			int decelerateRate = buff.getValue()[0];
			defender.getAttributeInfo().updateAttribute(AttributeType.SPEED_PERCENT, -decelerateRate);
		}
	}

	@Override
	public void removeBuff(BuffDo buff, HeroDo target, BattleContext context) {
		int decelerateRate = buff.getBuff().getValue()[0];
		target.getAttributeInfo().updateAttribute(AttributeType.SPEED_PERCENT, decelerateRate);
	}
}
