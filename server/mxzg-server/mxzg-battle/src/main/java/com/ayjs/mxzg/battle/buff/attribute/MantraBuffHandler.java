package com.ayjs.mxzg.battle.buff.attribute;

import com.ayjs.mxzg.config.struct.BuffType;
import org.springframework.stereotype.Component;

/**
 * 咒印
 * @author meiyc
 *
 */
@Component
public class MantraBuffHandler extends AbstractAttributeBuffHandler {

	@Override
	public BuffType getType() {
		return BuffType.BT_MANTRA;
	}

}
