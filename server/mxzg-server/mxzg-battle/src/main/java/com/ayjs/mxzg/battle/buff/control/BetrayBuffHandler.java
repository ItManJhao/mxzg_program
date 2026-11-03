/**
 * 
 */
package com.ayjs.mxzg.battle.buff.control;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.config.struct.BuffType;

/**
 * @author YY
 *
 */
@Component
public class BetrayBuffHandler extends AbstractControlBuffHandler {

	@Override
	public BuffType getType() {
		return BuffType.BT_BETRAY;
	}
}
