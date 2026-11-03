/**
 * 
 */
package com.ayjs.mxzg.cross.module.clanwar.struct;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

/**
 * @author YY
 *
 */
public class ClanWarBattling {
	private final long clanId;
	//<路号，战斗队伍>
	private final Map<Integer, ClanWarRoadInfo> roadTeamMap = new ConcurrentHashMap<>();
	
	private final int serverId;
	
	public ClanWarBattling(long clanId, int serverId) {
		this.clanId = clanId;
		this.serverId = serverId;
	}
	
	public Map<Integer, ClanWarRoadInfo> getRoadTeamMap() {
		return roadTeamMap;
	}

	public long getClanId() {
		return clanId;
	}

	public int getServerId() {
		return serverId;
	}
}
