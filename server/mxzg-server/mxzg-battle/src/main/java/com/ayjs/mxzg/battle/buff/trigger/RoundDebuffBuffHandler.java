package com.ayjs.mxzg.battle.buff.trigger;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.config.struct.BuffType;

/**
 * 回合Debuff造成伤害时触发
 * @author meiyc
 *
 */
@Component
public class RoundDebuffBuffHandler extends AbstractArtTriggerBuffHandler {

	@Override
	public BuffType getType() {
		return BuffType.BT_ROUND_DEBUFF;
	}

}
