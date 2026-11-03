package com.ayjs.mxzg.battle.buff.control;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.config.struct.BuffType;

/**
 * 眩晕
 * @author meiyc
 *
 */
@Component
public class DizzyBuffHandler extends AbstractControlBuffHandler {

	@Override
	public BuffType getType() {
		return BuffType.BT_DIZZY;
	}

}
