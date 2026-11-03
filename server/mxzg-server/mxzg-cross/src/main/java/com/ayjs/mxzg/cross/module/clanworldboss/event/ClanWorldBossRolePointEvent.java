/**
 * 
 */
package com.ayjs.mxzg.cross.module.clanworldboss.event;

import lombok.Value;

/**
 * @author YY
 * 世界BOSS玩家积分变动事件
 */
@Value(staticConstructor = "of")
public class ClanWorldBossRolePointEvent {
	private long rid;
	private long clanId;
	private long point;
	private int time;
	private int serverId;
}
