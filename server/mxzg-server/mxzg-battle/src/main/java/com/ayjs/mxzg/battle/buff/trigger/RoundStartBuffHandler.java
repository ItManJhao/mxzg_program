package com.ayjs.mxzg.battle.buff.trigger;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.config.struct.BuffType;

/**
 * 回合开始时执行
 * @author meiyc
 *
 */
@Component
public class RoundStartBuffHandler extends AbstractArtTriggerBuffHandler {

	@Override
	public BuffType getType() {
		return BuffType.BT_ROUND_START;
	}

}
