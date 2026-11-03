/**
 * 
 */
package com.ayjs.mxzg.module.clanwar.constant;

import java.util.HashMap;
import java.util.Map;

/**
 * @author YY
 *
 */
public enum ClanWarRoad {
	LEFT(1),
	MIDDLE(2),
	RIGHT(3),
	
	;
	
	private static Map<Integer, ClanWarRoad> roadMap = new HashMap<>();
	static {
		for(ClanWarRoad road : ClanWarRoad.values()) {
			roadMap.put(road.road, road);
		}
	}
	private final int road;
	private ClanWarRoad(int road) {
		this.road = road;
	}
	
	public static ClanWarRoad valueOf(int road) {
		return roadMap.get(road);
	}

	public int getRoad() {
		return road;
	}
}
