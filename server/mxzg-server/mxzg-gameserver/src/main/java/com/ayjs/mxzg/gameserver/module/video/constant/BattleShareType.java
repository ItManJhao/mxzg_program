/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.video.constant;

/**
 * @author YY
 *
 */
public enum BattleShareType {
	BATTLE("BATTLE"),
	SYS_VIDEO("SYS_VIDEO"),
	ROLE_VIDEO("ROLE_VIDEO"),
	;
	
	public final String value;
	private BattleShareType(String value) {
		this.value = value;
	}
	public String getValue() {
		return value;
	}
}
