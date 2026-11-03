package com.ayjs.mxzg.battle.buff;

import com.ayjs.mxzg.battle.model.*;
import com.ayjs.mxzg.battle.util.AttributeUtil;
import com.ayjs.mxzg.config.excel.entity.CBuff;
import com.ayjs.mxzg.config.struct.AttributeType;
import com.ayjs.mxzg.config.struct.BuffType;
import com.ayjs.mxzg.protocol.BattleGMsg;
import com.ayjs.mxzg.protocol.BattleGMsg.BuffInfo;
import com.ayjs.mxzg.protocol.BattleGMsg.BuffInfo.Builder;

import java.util.List;

/**
 * 基础的伤害buff，提供伤害构造，护盾消耗等方法
 * @author meiyc
 *
 */
public abstract class AbstractBaseDamageBuffHandler extends AbstractBuffHandler {


	/**
	 * 计算攻击百分比的伤害
	 * @param buff
	 * @param attacker
	 * @param target
	 * @return
	 */
	protected DamageResult calDamage(CBuff buff, HeroDo attacker, HeroDo target){
		int attackRatio = buff.getValue()[0];
		long attack = attacker.getAttribute(AttributeType.ATTACK);
		long damage = AttributeUtil.addPercent(attack, attackRatio);
		return DamageResult.builder().damage(-damage).fixedAttack(true).hitType(HitType.HIT).build();
	}

	/**
	 * 添加一个额外目标的伤害buff，这里要触发额外目标受到伤害的触发事件
	 * @param buff
	 * @param result
	 * @param attacker
	 * @param defender
	 * @param context
	 */
	protected void addDamageBuff(CBuff buff, DamageResult result, HeroDo attacker, HeroDo defender, BattleContext context){
		BuffInfo.Builder builder = BuffInfo.newBuilder();
		int damageBuffId = result.getBuffId() == 0 ? buff.getIdx() : result.getBuffId();
		buildBuff(damageBuffId, defender, builder, context);
		deductionDamage(result, attacker, defender, builder, context);
		context.addEffectInfoBy(builder.build());
		battleTrigger.triggerDefender(buff, result, attacker, defender, context, builder);
		builder.setStatus(defender.getStatus().ordinal());
	}

	/**
	 * 扣减伤害
	 * @param result
	 * @param attacker
	 * @param defender
	 * @param builder
	 * @param context
	 */
	protected  void deductionDamage(DamageResult result, HeroDo attacker, HeroDo defender, Builder builder, BattleContext context){
		long shieldValue = consumeShield(defender, result, context);
		context.heroHurt(defender, attacker, result, shieldValue);
		if(result.getDamage() < 0 || result.getHitType() == HitType.BLOCK){
			buildDamage(result, defender, builder);
		}

		if(shieldValue > 0){
			builder.addUpdate(BattleGMsg.AttributeUpdate.newBuilder().setType(AttributeType.SHIELD.getValue()).setValue(-shieldValue).build());
		}
		builder.setStatus(defender.getStatus().ordinal());
		if(result.isBear()){
			builder.addResistances(1);
		}
	}

	/**
	 * 构建伤害结果到builder
	 * @param result
	 * @param defender
	 * @param builder
	 */
	protected void buildDamage(DamageResult result,HeroDo defender, Builder builder){
		BattleGMsg.AttributeUpdate attributeUpdate = BattleGMsg.AttributeUpdate.newBuilder().setType(AttributeType.HP.getValue()).setValue(result.getDamage()).build();
		builder.addUpdate(attributeUpdate).setHit(result.getType()).setStatus(defender.getStatus().ordinal());
	}

	/**
	 * 消耗护盾
	 * @param defender
	 * @param result
	 * @param context
	 */
	protected long consumeShield(HeroDo defender, DamageResult result, BattleContext context){
		long totalDamageValue = Math.abs(result.getDamage());
		long shieldValue = 0;
		List<BuffDo> buffDos = defender.getBuffsBy(BuffType.BT_SHIELD);
		for (BuffDo buffDo : buffDos) {
			long damageValue = totalDamageValue > buffDo.getValue() ? buffDo.getValue() : totalDamageValue;
			shieldValue += damageValue;
			buffDo.addValue(-damageValue);
			if(buffDo.getValue() == 0){
				buffHelper.removeBuff(buffDo, defender, context);
			}
			totalDamageValue -= damageValue;
			if(totalDamageValue == 0){
				break;
			}
		}
		result.updateDamage(shieldValue);
		return shieldValue;
	}


}
