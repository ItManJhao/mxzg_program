/**
 * 
 */
package com.ayjs.mxzg.cross.module.clanworldboss.event;

import lombok.Value;

/**
 * @author YY
 * 世界BOSS公会积分变动事件
 */
@Value(staticConstructor = "of")
public class ClanWorldBossClanPointEvent {
	private long clanId;
	private int time;
	private int serverId;
}
