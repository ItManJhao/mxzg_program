package com.ayjs.mxzg.battle.buff.function;

import com.ayjs.mxzg.battle.buff.AbstractDebuffHandler;
import com.ayjs.mxzg.config.struct.BuffType;
import org.springframework.stereotype.Component;

/**
 * 封印buff
 * @author meiyc
 *
 */
@Component
public class SealBuffHandler extends AbstractDebuffHandler {

	@Override
	public BuffType getType() {
		return BuffType.BT_SEAL;
	}

}
