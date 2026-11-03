/**
 * 
 */
package com.ayjs.mxzg.battle.buff.trigger;

import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.BuffDo;
import com.ayjs.mxzg.battle.model.DamageResult;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.battle.model.HitType;
import com.ayjs.mxzg.config.struct.BuffType;
import org.springframework.stereotype.Component;

/**
 * @author YY
 *
 */
@Component
public class BlockShieldBuffHandler extends AbstractArtTriggerBuffHandler {

	@Override
	public BuffType getType() {
		return BuffType.BT_BLOCK_SHIELD;
	}

	@Override
	public void trigger(BuffDo buff, HeroDo beTrigger, HeroDo target, BattleContext context) {
		DamageResult result = target.getResult();
		if(!result.isFixedAttack()) {
			buff.addValue(1);
			result.setDamage(0);
			result.setHitType(HitType.BLOCK);
			if(buff.getValue() >= buff.getBuff().getValue()[0]) {
				buffHelper.removeBuff(buff, beTrigger, context);
			}
		}
	}

}
