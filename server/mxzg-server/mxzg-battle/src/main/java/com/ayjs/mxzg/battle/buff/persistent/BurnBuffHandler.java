package com.ayjs.mxzg.battle.buff.persistent;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.config.struct.BuffType;

/**
 * 灼烧buff
 * @author meiyc
 *
 */
@Component
public class BurnBuffHandler extends AbstractPersistentBuffHandler {

	@Override
	public BuffType getType() {
		return BuffType.BT_BURN;
	}

}
