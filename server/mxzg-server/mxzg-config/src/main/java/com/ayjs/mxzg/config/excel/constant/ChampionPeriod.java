/**
 * 
 */
package com.ayjs.mxzg.config.excel.constant;

/**
 * @author YY
 *
 */
public enum ChampionPeriod {
	IDLE(0, "空闲"),
	TRIALS(1, "选拔赛"),
	KNOCKOUT(2, "淘汰赛"),
	;
	
	private final int value;
	private final String note;
	private ChampionPeriod(int value, String note) {
		this.value = value;
		this.note = note;
	}
	public int getValue() {
		return value;
	}
	public String getNote() {
		return note;
	}
}
