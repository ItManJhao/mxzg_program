package com.ayjs.mxzg.battle.buff.function;

import com.ayjs.mxzg.battle.buff.AbstractDebuffHandler;
import com.ayjs.mxzg.config.struct.BuffType;
import org.springframework.stereotype.Component;

/**
 * 免疫debuff
 */
@Component
public class ImmunityDebuffBuffHandler extends AbstractDebuffHandler {

	@Override
	public BuffType getType() {
		return BuffType.BT_IMMUNITY_DEBUFF;
	}

}
