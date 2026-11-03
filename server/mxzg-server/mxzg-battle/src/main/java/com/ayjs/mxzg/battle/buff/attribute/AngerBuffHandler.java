package com.ayjs.mxzg.battle.buff.attribute;

import com.ayjs.mxzg.config.struct.BuffType;
import org.springframework.stereotype.Component;

/**
 * 怒气buff
 * @author meiyc
 *
 */
@Component
public class AngerBuffHandler extends AbstractAttributeBuffHandler {

	@Override
	public BuffType getType() {
		return BuffType.BT_ANGER;
	}


}
