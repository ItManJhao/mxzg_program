/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.clan.event;

import lombok.Value;

/**
 * @author YY
 * 公会新成员入会事件
 */
@Value(staticConstructor = "of")
public class ClanMemberJoinEvent {
	private long rid;
	private long clanId;
}
