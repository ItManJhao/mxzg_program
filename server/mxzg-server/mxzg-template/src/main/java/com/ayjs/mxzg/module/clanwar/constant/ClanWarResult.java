/**
 * 
 */
package com.ayjs.mxzg.module.clanwar.constant;

/**
 * @author YY
 *
 */
public enum ClanWarResult {
	NONE(0),
	WIN(1),
	LOSE(2),
	;
	
	private final int value;
	private ClanWarResult(int value) {
		this.value = value;
	}
	public int getValue() {
		return value;
	}
}
