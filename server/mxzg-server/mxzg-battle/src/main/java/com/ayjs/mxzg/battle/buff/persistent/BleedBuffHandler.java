package com.ayjs.mxzg.battle.buff.persistent;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.config.struct.BuffType;

/**
 * 流血buff
 * @author meiyc
 *
 */
@Component
public class BleedBuffHandler extends AbstractPersistentBuffHandler {


	@Override
	public BuffType getType() {
		return BuffType.BT_BLEED;
	}

	
}
