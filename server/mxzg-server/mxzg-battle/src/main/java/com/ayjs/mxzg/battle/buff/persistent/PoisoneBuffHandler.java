package com.ayjs.mxzg.battle.buff.persistent;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.config.struct.BuffType;

/**
 * 中毒buff
 * @author meiyc
 *
 */
@Component
public class PoisoneBuffHandler extends AbstractPersistentBuffHandler {

	@Override
	public BuffType getType() {
		return BuffType.BT_POISONE;
	}

}
