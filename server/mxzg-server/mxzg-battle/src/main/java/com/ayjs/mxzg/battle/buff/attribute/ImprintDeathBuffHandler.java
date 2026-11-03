package com.ayjs.mxzg.battle.buff.attribute;

import com.ayjs.mxzg.config.struct.BuffType;
import org.springframework.stereotype.Component;

/**
 * 死亡印记
 * @author meiyc
 *
 */
@Component
public class ImprintDeathBuffHandler extends AbstractAttributeBuffHandler {

	@Override
	public BuffType getType() {
		return BuffType.BT_IMPRINT_DEATH;
	}
	

}
