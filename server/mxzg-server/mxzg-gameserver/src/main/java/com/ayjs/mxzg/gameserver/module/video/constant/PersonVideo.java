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
public enum PersonVideo {

	RECORD(1),
	KEEP(2),
	;
	private static Map<Integer, PersonVideo> typeMap = new HashMap<>();
	static {
		for(PersonVideo type : PersonVideo.values()) {
			typeMap.put(type.getValue(), type);
		}
	}
	private final int value;
	private PersonVideo(int value) {
		this.value = value;
	}
	public int getValue() {
		return value;
	}
	public static PersonVideo valueOf(int value) {
		return typeMap.get(value);
	}
}
