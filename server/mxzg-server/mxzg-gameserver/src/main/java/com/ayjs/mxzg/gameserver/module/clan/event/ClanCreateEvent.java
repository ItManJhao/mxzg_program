/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.clan.event;

import lombok.Value;

/**
 * @author YY
 * 公会创建事件
 */
@Value(staticConstructor = "of")
public class ClanCreateEvent {
	private long rid;
	private long clanId;
}
