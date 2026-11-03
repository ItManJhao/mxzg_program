/**
 * 
 */
package com.ayjs.mxzg.config.excel.constant;

import java.util.HashMap;
import java.util.Map;


public enum PinnacleStage {
	MATCH(0, "匹配"),
	PREPARE(1, "准备"),
	GUESS(2, "竞猜"),
	BATTLE(3, "战斗"),
	;


	private static Map<Integer, PinnacleStage> stageMap = new HashMap<>();
	static {
		for(PinnacleStage stage : PinnacleStage.values()) {
			stageMap.put(stage.getValue(), stage);
		}
	}

	private int value;
	private String desc;
	private PinnacleStage(int value, String desc) {
		this.value = value;
		this.desc = desc;
	}
	public int getValue() {
		return value;
	}
	public String getDesc() {
		return desc;
	}
	
	public static PinnacleStage of(int value) {
		return stageMap.get(value);
	}
}
