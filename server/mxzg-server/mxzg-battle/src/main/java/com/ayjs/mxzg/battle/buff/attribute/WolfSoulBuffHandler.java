package com.ayjs.mxzg.battle.buff.attribute;

import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.BuffDo;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.config.excel.entity.CBuff;
import com.ayjs.mxzg.config.struct.AttributeType;
import com.ayjs.mxzg.config.struct.BuffType;
import com.ayjs.mxzg.protocol.BattleGMsg.AttributeUpdate;
import com.ayjs.mxzg.protocol.BattleGMsg.BuffInfo.Builder;
import org.springframework.stereotype.Component;

/**
 * 狼魂，增加属性
 * @author meiyc
 *
 */
@Component
public class WolfSoulBuffHandler extends AbstractBaseAttributeBuffHandler {

	@Override
	public BuffType getType() {
		return BuffType.BT_WOLF_SOUL;
	}

	@Override
	protected void handleEffect(BuffDo buffDo, HeroDo attacker, HeroDo target, Builder builder) {
		int criRatio = buffDo.getBuff().getValue()[0];
		int reducePercent = buffDo.getBuff().getValue()[1];

		target.getAttributeInfo().updateAttribute(AttributeType.CRIT_PERCENT, criRatio);
		target.getAttributeInfo().updateAttribute(AttributeType.FINAL_DAMAGE_REDUCE_PERCENT, reducePercent);

		builder.addUpdate(AttributeUpdate.newBuilder().setType(AttributeType.CRIT_PERCENT.getValue()).setValue(criRatio));
		builder.addUpdate(AttributeUpdate.newBuilder().setType(AttributeType.FINAL_DAMAGE_REDUCE_PERCENT.getValue()).setValue(reducePercent));
	}

	@Override
	public void handle(CBuff buff, HeroDo attacker, HeroDo defender, BattleContext context, Builder builder) {
		int criRatio = buff.getValue()[0];
		int reducePercent = buff.getValue()[1];

		defender.getAttributeInfo().updateAttribute(AttributeType.CRIT_PERCENT, -criRatio);
		defender.getAttributeInfo().updateAttribute(AttributeType.FINAL_DAMAGE_REDUCE_PERCENT, -reducePercent);

		builder.addUpdate(AttributeUpdate.newBuilder().setType(AttributeType.CRIT_PERCENT.getValue()).setValue(-criRatio));
		builder.addUpdate(AttributeUpdate.newBuilder().setType(AttributeType.FINAL_DAMAGE_REDUCE_PERCENT.getValue()).setValue(-reducePercent));
	}


}
