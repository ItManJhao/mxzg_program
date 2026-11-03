/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.clanwar.event;

import lombok.Value;

/**
 * @author YY
 *
 */
@Value(staticConstructor = "of")
public class ClanWarWinEvent {
	private long clanId;
}
