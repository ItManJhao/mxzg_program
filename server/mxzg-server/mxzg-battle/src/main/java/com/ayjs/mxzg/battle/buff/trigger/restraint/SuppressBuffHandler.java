package com.ayjs.mxzg.battle.buff.trigger.restraint;

import com.ayjs.mxzg.battle.buff.trigger.AbstractArtTriggerBuffHandler;
import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.BuffDo;
import com.ayjs.mxzg.battle.model.DamageResult;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.battle.util.AttributeUtil;
import com.ayjs.mxzg.config.struct.BuffType;
import com.google.common.collect.Sets;
import org.springframework.stereotype.Component;

import java.util.Set;

/**
 * 镇压
 * @author meiyc
 *
 */
@Component
public class SuppressBuffHandler extends AbstractArtTriggerBuffHandler {

	private Set<BuffType> associatedBuff = Sets.newHashSet(BuffType.BT_VITALITY, BuffType.BT_REGENERATION);

	@Override
	public BuffType getType() {
		return BuffType.BT_SUPPRESS;
	}

	@Override
	public void trigger(BuffDo buff, HeroDo beTrigger, HeroDo target, BattleContext context) {
		if(target.haveBuff(associatedBuff)){
			int damageAdd = buff.getBuff().getValue()[0];
			DamageResult result = beTrigger.getResult();
			long damage = AttributeUtil.addPercent(result.getDamage(), damageAdd);
			result.updateDamage(damage);
		}
	}

}
