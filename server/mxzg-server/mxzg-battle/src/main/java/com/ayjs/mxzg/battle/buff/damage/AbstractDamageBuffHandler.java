package com.ayjs.mxzg.battle.buff.damage;

import com.ayjs.mxzg.battle.buff.AbstractBaseDamageBuffHandler;
import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.DamageResult;
import com.ayjs.mxzg.battle.model.FightEventType;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.config.excel.entity.CBuff;
import com.ayjs.mxzg.config.struct.AttributeType;
import com.ayjs.mxzg.config.struct.BuffType;
import com.ayjs.mxzg.protocol.BattleGMsg.BuffInfo;
import com.ayjs.mxzg.protocol.BattleGMsg.BuffInfo.Builder;

/**
 * 抽象的伤害buff
 * @author meiyc
 *
 */
public abstract class AbstractDamageBuffHandler extends AbstractBaseDamageBuffHandler {


	@Override
	public void handle(CBuff buff, HeroDo attacker, HeroDo defender, BattleContext context, Builder builder) {
		if (attacker.notDeadTrigger() || defender.isDead()) return;

		battleTrigger.trigger(BuffType.BT_BEFORE_DAMAGE, attacker, defender, context);
		DamageResult result = calDamage(buff, attacker, defender, context);
		if(!result.isEmpty() ){
			handleCalDamageAfter(result, buff, attacker, defender, context, builder);
		}
	}

	/**
	 * 处理计算伤害之后的逻辑
	 * @param result
	 * @param buff
	 * @param attacker
	 * @param defender
	 * @param context
	 * @param builder
	 */
	protected void handleCalDamageAfter(DamageResult result, CBuff buff, HeroDo attacker, HeroDo defender, BattleContext context, Builder builder){
		buildBuff(buff.getIdx(), defender, builder, context);
		result.setBuffId(buff.getIdx());
		attacker.addDamageResult(result);
		if(result.isMiss()){
			buildDamage(result, defender, builder);
			defender.getEventDo().increase(FightEventType.MISS);
			battleTrigger.trigger(BuffType.BT_EVENT, defender, attacker, context);
			return;
		}

		if(result.getDamage() == 0){return;}

		battleTrigger.trigger(BuffType.BT_AFTER_DAMAGE, attacker, defender, context);
		battleTrigger.trigger(BuffType.BT_BEFORE_DEDUCTION_DAMAGE, defender, attacker, context);
		deductionDamage(result, attacker, defender, builder, context);

		if(result.isBlock()){
			builder.addResistances(AttributeType.BLOCK_PERCENT.getValue());
		}

		battleTrigger.triggerAttacker(buff, result, attacker, defender, context, builder);
		battleTrigger.triggerDefender(buff, result, attacker, defender, context, builder);
		if (buff.isCounterattack() || attacker.getActionInfo().isCounterattack()) {
			attacker.closeCounterattack(defender.getUnitId());
		}
	}

	/**
	 * 添加一个技能伤害，需要走完整的技能触发流程时才能调用，技能额外伤害不需要调用
	 * @param result
	 * @param buff
	 * @param attacker
	 * @param defender
	 * @param context
	 */
	protected void addSkillDamage(DamageResult result, CBuff buff, HeroDo attacker, HeroDo defender, BattleContext context){
		BuffInfo.Builder builder = BuffInfo.newBuilder();
		handleCalDamageAfter(result, buff, attacker, defender, context, builder);
		context.addEffectInfoBy(builder.build());
	}

	/**
	 * 计算伤害
	 * @param buff
	 * @param attacker
	 * @param defender
	 * @param context
	 * @return
	 */
	protected abstract DamageResult calDamage(CBuff buff, HeroDo attacker, HeroDo defender, BattleContext context);
	
}
