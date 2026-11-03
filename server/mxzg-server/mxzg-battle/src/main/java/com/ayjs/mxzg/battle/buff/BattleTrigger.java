package com.ayjs.mxzg.battle.buff;

import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.BattlerDo;
import com.ayjs.mxzg.battle.model.BuffDo;
import com.ayjs.mxzg.battle.model.DamageResult;
import com.ayjs.mxzg.battle.model.FightEventType;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.battle.model.SkillDo;
import com.ayjs.mxzg.config.excel.entity.CBuff;
import com.ayjs.mxzg.config.struct.ActiveType;
import com.ayjs.mxzg.config.struct.BuffType;
import com.ayjs.mxzg.protocol.BattleGMsg.BuffInfo.Builder;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.Collections;
import java.util.List;


/**
 * 战场触发器
 * @author meiyc
 *
 */
@Component
public class BattleTrigger {

	@Autowired
	private BuffHelper buffHelper;
	@Autowired
	private BuffHandlerHolder buffHandlerHolder;

	/**
	 * 触发buff类型
	 * @param type
	 * @param beTrigger
	 * @param target
	 * @param context
	 */
	public void trigger(BuffType type, HeroDo beTrigger, HeroDo target, BattleContext context){
		if(beTrigger == null || beTrigger.isSeal()){
			return;
		}
		List<BuffDo> buffDos = beTrigger.getListenTrigger(type);
		Collections.sort(buffDos);
		for (BuffDo buffDo : buffDos) {
			BuffHandler buffHandler = buffHandlerHolder.getBuffHandler(buffDo.getType());
			buffHandler.trigger(buffDo, beTrigger, target, context);
			beTrigger.restore();
		}
	}
	
	/**
	 * 攻击触发攻击方
	 * @param buff
	 * @param result
	 * @param attacker
	 * @param defender
	 * @param context
	 * @param builder
	 */
	public void triggerAttacker(CBuff buff, DamageResult result, HeroDo attacker, HeroDo defender, BattleContext context, Builder builder){
		if (!isCounterattack(buff, result, attacker, defender)) {
			return;
		}
		
		if(result.isCrit()){
			trigger(BuffType.BT_CRITICAL, attacker, defender, context);
		}
				
		BuffType damageTriggerType = attacker.getCurrentSkill().getSkill().getActive_type().getDamageTriggerType();
		trigger(damageTriggerType, attacker, defender, context);

		trigger(BuffType.BT_DEALING_DAMAGE, attacker, defender, context);

		if(defender.isDead()){
			trigger(BuffType.BT_KILLED, attacker, defender, context);
		}
	}
	
	/**
	 * 触发被攻击的防守方
	 * @param buff
	 * @param result
	 * @param attacker
	 * @param defender
	 * @param context
	 * @param builder
	 */
	public void triggerDefender(CBuff buff, DamageResult result, HeroDo attacker, HeroDo defender, BattleContext context, Builder builder){
		if(defender.isDead()){
			builder.setStatus(defender.getStatus().ordinal());
			defender.setDeathTrigger(true);
			trigger(BuffType.BT_DEATH, defender, attacker, context);
			defender.setDeathTrigger(false);
			buffHelper.removeByDead(defender, context);
			attacker.interrupt(defender.getUnitId());
			return;
		}

		trigger(BuffType.BT_BEDAMAGE_HP_MAXIMUM, defender, attacker, context);

		if (!isCounterattack(buff, result, attacker, defender)) {
			return;
		}

		if(result.isCrit()){
			trigger(BuffType.BT_BECRITICAL, defender, attacker, context);
		}
		
		if(result.isBlock()){
			trigger(BuffType.BT_BLOCK_TRIGGER, defender, attacker, context);
			defender.getEventDo().increase(FightEventType.BLOCK);
			trigger(BuffType.BT_EVENT, defender, attacker, context);
		}

		trigger(BuffType.BT_BEDAMAGE_HP_STAGE, defender, attacker, context);
		if(result.isFixedAttack()){
			return;
		}

		SkillDo skill = attacker.getCurrentSkill();
		if(skill != null){
			ActiveType activeType = skill.getSkill().getActive_type();
			trigger(activeType.getBeattackTriggerType(), defender, attacker, context);
			trigger(BuffType.BT_BEATTACK, defender, attacker, context);
		}
	}

	/**
	 * 触发全部队友
	 * @param type
	 * @param beTrigger
	 * @param context
	 */
	public void triggerTeammate(BuffType type, HeroDo beTrigger, BattleContext context){
		BattlerDo self = context.getSelf(beTrigger.getFaction());
		for (HeroDo hero : self.getHeros()) {
			trigger(type, hero, beTrigger, context);
		}
	}

	/**
	 * 是否能反击
	 *
	 * @param buff
	 * @param result
	 * @param attacker
	 * @param defender
	 * @return
	 */
	private boolean isCounterattack(CBuff buff, DamageResult result, HeroDo attacker, HeroDo defender) {
		return !result.isFixedAttack() && buff.isCounterattack() && !attacker.isCounterattack() && !attacker.isTriggeredCounterattack(defender.getUnitId());
	}

}
