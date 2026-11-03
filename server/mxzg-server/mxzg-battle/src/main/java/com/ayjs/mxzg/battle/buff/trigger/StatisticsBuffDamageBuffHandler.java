/**
 * 
 */
package com.ayjs.mxzg.battle.buff.trigger;

import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.BuffDo;
import com.ayjs.mxzg.battle.model.DamageResult;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.config.struct.BuffType;
import org.springframework.stereotype.Component;

import java.util.Optional;

/**
 * 统计debuff造成的伤害
 */
@Component
public class StatisticsBuffDamageBuffHandler extends AbstractArtTriggerBuffHandler {


	@Override
	public BuffType getType() {
		return BuffType.BT_STATISTICS_BUFF_DAMAGE;
	}

	@Override
	public void trigger(BuffDo buff, HeroDo beTrigger, HeroDo target, BattleContext context) {
		HeroDo source = context.getHero(buff.getSourceId());
		DamageResult damageResult = target.getResult();
		Optional<BuffDo> treatmentBuff = source.getBuffBy(BuffType.BT_ACCORDING_TREATMENT, source.getUnitId());
		if(treatmentBuff.isPresent()){
			treatmentBuff.get().addValue(damageResult.getDamage());
		}
	}

}
