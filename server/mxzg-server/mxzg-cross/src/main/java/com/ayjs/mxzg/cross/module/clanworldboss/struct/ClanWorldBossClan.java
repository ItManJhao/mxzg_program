/**
 * 
 */
package com.ayjs.mxzg.cross.module.clanworldboss.struct;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

/**
 * @author YY
 * 公会BOSS战的公会信息
 */
public class ClanWorldBossClan {
	private final long clanId;
	
	private long point;
	
	private final Map<Long, Long> joinMembers = new ConcurrentHashMap<>();

	public ClanWorldBossClan(long clanId) {
		this.clanId = clanId;
	}
	
	public long getClanId() {
		return clanId;
	}

	public long getPoint() {
		return point;
	}

	public Map<Long, Long> getJoinMembers() {
		return joinMembers;
	}

	public void setPoint(long point) {
		this.point = point;
	}
}
