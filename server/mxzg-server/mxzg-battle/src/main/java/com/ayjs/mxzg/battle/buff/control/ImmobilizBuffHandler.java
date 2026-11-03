package com.ayjs.mxzg.battle.buff.control;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.config.struct.BuffType;

/**
 * 定身
 * @author meiyc
 *
 */
@Component
public class ImmobilizBuffHandler extends AbstractControlBuffHandler {

	@Override
	public BuffType getType() {
		return BuffType.BT_IMMOBILIZ;
	}

}
