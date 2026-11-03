package com.ayjs.mxzg.battle.buff.control;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.config.struct.BuffType;

/**
 * 沉默buff
 * @author meiyc
 *
 */
@Component
public class SilenceBuffHandler extends AbstractControlBuffHandler {

	@Override
	public BuffType getType() {
		return BuffType.BT_SILENCE;
	}

}
