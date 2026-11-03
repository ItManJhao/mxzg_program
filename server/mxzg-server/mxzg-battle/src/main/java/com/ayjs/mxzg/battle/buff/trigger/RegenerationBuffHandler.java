package com.ayjs.mxzg.battle.buff.trigger;

import com.ayjs.mxzg.config.struct.BuffType;
import org.springframework.stereotype.Component;

/**
 * 再生，每回合开始恢复一定比例生命值
 * @author meiyc
 *
 */
@Component
public class RegenerationBuffHandler extends AbstractArtTriggerBuffHandler {

	@Override
	public BuffType getType() {
		return BuffType.BT_REGENERATION;
	}

}
