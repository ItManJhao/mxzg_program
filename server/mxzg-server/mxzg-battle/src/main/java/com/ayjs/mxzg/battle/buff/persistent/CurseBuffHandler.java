package com.ayjs.mxzg.battle.buff.persistent;

import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.BuffDo;
import com.ayjs.mxzg.battle.model.DamageResult;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.config.struct.BuffType;
import com.ayjs.mxzg.protocol.BattleGMsg.BuffInfo.Builder;
import org.springframework.stereotype.Component;

import java.util.List;

/**
 * 诅咒，执行固定buff掉血，可以被技能引爆
 * @author meiyc
 *
 */
@Component
public class CurseBuffHandler extends AbstractPersistentBuffHandler {


	@Override
	public BuffType getType() {
		return BuffType.BT_CURSE;
	}

	@Override
	public void executeRound(BuffDo buff, HeroDo target, BattleContext context, Builder builder) {
		if(buff.isExpired(context.currentRound())){
			super.executeRound(buff, target, context, builder);
		}
	}

	@Override
	public void trigger(BuffDo buff, HeroDo betrigger, HeroDo target, BattleContext context) {
	    if(target.getUnitId() != buff.getSourceId()){
	        return;
        }
		List<Integer> triggerSkillIds = buff.getBuff().getValues().subList(1, buff.getBuff().getValues().size());
		if(triggerSkillIds.contains(target.getCurrentSkill().getSkillId())){
			HeroDo attacker = context.getHero(buff.getSourceId());
			DamageResult result = calDamage(buff.getBuff(), attacker, betrigger);
			attacker.setResult(result);
			battleTrigger.trigger(BuffType.BT_ROUND_DEBUFF, target, attacker, context);
			battleTrigger.triggerTeammate(BuffType.BT_CURE_DAMAGE_AFTER, attacker, context);
			addDamageBuff(buff.getBuff(), result, target, betrigger, context);
			buffHelper.removeBuff(buff, betrigger, context);
		}
	}

}
