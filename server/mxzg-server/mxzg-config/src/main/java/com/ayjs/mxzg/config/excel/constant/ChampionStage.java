/**
 * 
 */
package com.ayjs.mxzg.config.excel.constant;

import java.util.HashMap;
import java.util.Map;

/**
 * @author YY
 *
 */
public enum ChampionStage {
	MATCH(0, "匹配"),
	PREPARE(1, "准备"),
	GUESS(2, "竞猜"),
	BATTLE(3, "战斗"),
	;
	
	
	private static Map<Integer, ChampionStage> stageMap = new HashMap<>();
	static {
		for(ChampionStage stage : ChampionStage.values()) {
			stageMap.put(stage.getValue(), stage);
		}
	}
	
	private int value;
	private String desc;
	private ChampionStage(int value, String desc) {
		this.value = value;
		this.desc = desc;
	}
	public int getValue() {
		return value;
	}
	public String getDesc() {
		return desc;
	}
	
	public static ChampionStage of(int value) {
		return stageMap.get(value);
	}
}
