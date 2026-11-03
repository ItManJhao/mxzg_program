/**
 * 
 */
package com.ayjs.mxzg.battle.buff.trigger;

import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.BuffDo;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.battle.util.AttributeUtil;
import com.ayjs.mxzg.common.util.RandomUtils;
import com.ayjs.mxzg.config.struct.BuffType;
import org.springframework.stereotype.Component;

/**
 * 火灵守护，受到攻击时给攻击者附加buff
 */
@Component
public class FireSpiritBuffHandler extends AbstractArtTriggerBuffHandler {


	@Override
	public BuffType getType() {
		return BuffType.BT_FIRE_SPIRIT;
	}

	@Override
	public void trigger(BuffDo buff, HeroDo beTrigger, HeroDo target, BattleContext context) {
		int rate = buff.getBuff().getValue()[0];
		double randomValue = AttributeUtil.calPercent(rate);
		if(RandomUtils.isHit(randomValue)){
			int artId = buff.getBuff().getValue()[1];
			battleService.executeBuffArt(artId, target, beTrigger, context);
		}
	}

}
