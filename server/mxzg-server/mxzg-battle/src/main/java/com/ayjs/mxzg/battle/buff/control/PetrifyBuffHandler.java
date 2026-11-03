package com.ayjs.mxzg.battle.buff.control;

import com.ayjs.mxzg.config.struct.BuffType;
import org.springframework.stereotype.Component;

/**
 * 石化
 * @author meiyc
 *
 */
@Component
public class PetrifyBuffHandler extends AbstractControlBuffHandler {

	@Override
	public BuffType getType() {
		return BuffType.BT_PETRIFY;
	}

}
