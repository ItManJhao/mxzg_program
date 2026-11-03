/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.clanworldboss.event;

import lombok.Value;

/**
 * @author YY
 * 世界BOSS公会获得第一名事件
 */
@Value(staticConstructor = "of")
public class ClanWorldBossFirstEvent {
	private String firstRole;
	private int firstRoleServer;
	private String firstClan;
	private int firstClanServer;
}
