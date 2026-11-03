package com.ayjs.mxzg.battle.buff.replenish;

import com.ayjs.mxzg.battle.buff.AbstractBuffHandler;
import com.ayjs.mxzg.battle.buff.BattleTrigger;
import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.config.excel.entity.CBuff;
import com.ayjs.mxzg.config.struct.AttributeType;
import com.ayjs.mxzg.config.struct.BuffType;
import com.ayjs.mxzg.protocol.BattleGMsg.AttributeUpdate;
import com.ayjs.mxzg.protocol.BattleGMsg.BuffInfo.Builder;
import org.springframework.beans.factory.annotation.Autowired;

/**
 * 抽象的恢复类buff处理器
 * @author meiyc
 *
 */
public abstract class AbstractReplenishBuffHandler extends AbstractBuffHandler {

	@Autowired
	private BattleTrigger battleTrigger;

	@Override
	public void handle(CBuff buff, HeroDo attacker, HeroDo defender, BattleContext context, Builder builder) {
		if(defender.haveBuff(BuffType.BT_NO_RECOVERY)) {
			return;
		}
		long replenishHp = replenish(buff, attacker, defender, context);
		if(replenishHp <= 0){
			return;
		}
		buildBuff(buff.getIdx(), defender, builder, context);
		attacker.setLastTreatmentValue(replenishHp);
		battleTrigger.trigger(BuffType.BT_TREATMENT, attacker, defender, context);

		battleTrigger.trigger(BuffType.BT_BE_TREATED, defender,attacker,  context);
		replenishHp = attacker.getLastTreatmentValue();
		replenishHp = context.replenish(defender, attacker, replenishHp);

		AttributeUpdate attributeUpdate = AttributeUpdate.newBuilder().setType(AttributeType.HP.getValue()).setValue(replenishHp).build();
		builder.addUpdate(attributeUpdate);

		battleTrigger.trigger(BuffType.BT_PURE_HEART, attacker, defender, context);
	}
	
	/**
	 * 恢复血量
	 * @param buff
	 * @param attacker
	 * @param defender
	 * @param context
	 * @return
	 */
	protected abstract long replenish(CBuff buff, HeroDo attacker, HeroDo defender, BattleContext context);

}
