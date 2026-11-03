package com.ayjs.mxzg.battle.buff.trigger;

import com.ayjs.mxzg.config.struct.BuffType;
import org.springframework.stereotype.Component;

/**
 * 重生时触发
 * @author meiyc
 *
 */
@Component
public class RebirthBuffHandler extends AbstractArtTriggerBuffHandler {

	@Override
	public BuffType getType() {
		return BuffType.BT_REBIRTH;
	}
	
}
