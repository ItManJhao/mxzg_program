package com.ayjs.mxzg.battle.buff.persistent;

import com.ayjs.mxzg.battle.buff.AbstractDebuffHandler;
import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.BuffDo;
import com.ayjs.mxzg.battle.model.DamageResult;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.config.struct.BuffType;
import com.ayjs.mxzg.protocol.BattleGMsg.BuffInfo.Builder;
import lombok.extern.slf4j.Slf4j;

import java.util.Objects;

/**
 * 抽象的持续性buff基类
 * 
 * @author meiyc
 *
 */
@Slf4j
public abstract class AbstractPersistentBuffHandler extends AbstractDebuffHandler {

	@Override
	public void executeRound(BuffDo buff, HeroDo target, BattleContext context, Builder builder) {
		buildBuff(buff.getBuff().getIdx(), target, builder, context);
		HeroDo attacker = context.getHero(buff.getSourceId());
		if (Objects.isNull(attacker)) {
			return;
		}
		DamageResult result = calDamage(buff.getBuff(), attacker, target);
		attacker.setResult(result);
		battleTrigger.trigger(BuffType.BT_ROUND_DEBUFF, target, attacker, context);
		if(buff.getType() == BuffType.BT_CURSE){
			battleTrigger.triggerTeammate(BuffType.BT_CURE_DAMAGE_AFTER, attacker, context);
		}
		deductionDamage(result, attacker, target, builder, context);
		battleTrigger.triggerDefender(buff.getBuff(), result, attacker, target, context, builder);
	}

}
