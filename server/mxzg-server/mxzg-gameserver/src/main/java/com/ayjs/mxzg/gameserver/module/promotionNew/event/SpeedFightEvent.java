/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.promotionNew.event;

import lombok.Value;

/**
 * @author YY
 *
 */
@Value(staticConstructor = "of")
public class SpeedFightEvent {
	private long rid;
	public long getRid() {
		return rid;
	}
}
