/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.video.constant;

import java.util.HashMap;
import java.util.Map;

/**
 * @author YY
 *
 */
public enum VideoType {
	PVP(1, 1),
	WORLD_BOSS(2, 1),
	CHAMPION(3, 2),
	LADDER(4, 2),
	STUDY(5, 1),
	TEAM_ARENA(6, 1),
	;
	
	private static Map<Integer, VideoType> typeMap = new HashMap<>();
	static {
		for(VideoType type : VideoType.values()) {
			typeMap.put(type.getValue(), type);
		}
	}
	
	private final int value;
	//1只保存进攻方的个人录像馆，2保存战斗双方的个人录像馆
	private final int personType;
	
	private VideoType(int value, int personType) {
		this.value = value;
		this.personType = personType;
	}
	public int getValue() {
		return value;
	}
	public static VideoType valueOf(int value) {
		return typeMap.get(value);
	}
	public int getPersonType() {
		return personType;
	}
}
