package com.ayjs.mxzg.battle.buff.control;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.config.struct.BuffType;

/**
 * 缴械
 * @author meiyc
 *
 */
@Component
public class DisarmBuffHandler extends AbstractControlBuffHandler {

	@Override
	public BuffType getType() {
		return BuffType.BT_DISARM;
	}

}
