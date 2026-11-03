/**
 * 
 */
package com.ayjs.mxzg.battle.buff.trigger;

import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.BattlerDo;
import com.ayjs.mxzg.battle.model.BuffDo;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.battle.util.AttributeUtil;
import com.ayjs.mxzg.config.struct.AttributeType;
import com.ayjs.mxzg.config.struct.BuffType;
import com.ayjs.mxzg.protocol.BattleGMsg.AttributeUpdate;
import com.ayjs.mxzg.protocol.BattleGMsg.BuffInfo;
import com.ayjs.mxzg.protocol.BattleGMsg.BuffInfo.Builder;
import org.springframework.stereotype.Component;

/**
 * 根据buff统计伤害治疗全体
 */
@Component
public class AccordingTreatmentBuffHandler extends AbstractArtTriggerBuffHandler {


	@Override
	public BuffType getType() {
		return BuffType.BT_ACCORDING_TREATMENT;
	}

	@Override
	public void executeRound(BuffDo buff, HeroDo target, BattleContext context, Builder builder) {
		if(buff.getValue() < 0){
			BattlerDo battler = context.getSelf(target.getFaction());
			int convertRatio = buff.getBuff().getValue()[0];
			long totalValue = Math.abs(AttributeUtil.addPercent(buff.getValue(), convertRatio));
			long treatmentValue = totalValue / battler.getHeros().size();
			for(HeroDo defender : battler.getHeros()){
				BuffInfo.Builder buffBuilder = defender == target ? builder : BuffInfo.newBuilder();
				buildBuff(buff.getBuff().getIdx(), defender, buffBuilder, context);
				target.setLastTreatmentValue(treatmentValue);
				context.replenish(defender, target, treatmentValue);
				AttributeUpdate attributeUpdate = AttributeUpdate.newBuilder().setType(AttributeType.HP.getValue()).setValue(treatmentValue).build();
				buffBuilder.addUpdate(attributeUpdate);
				if(builder != buffBuilder){
					context.addUpdateBuff(buffBuilder.build());
				}
			}
			buff.setValue(0);
		}
	}
}
