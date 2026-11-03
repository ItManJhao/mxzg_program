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
public class AdventureRankEvent {
	private long rid;
	private int count;
	public long getRid() {
		return rid;
	}
	public int getCount() {
		return count;
	}
}
