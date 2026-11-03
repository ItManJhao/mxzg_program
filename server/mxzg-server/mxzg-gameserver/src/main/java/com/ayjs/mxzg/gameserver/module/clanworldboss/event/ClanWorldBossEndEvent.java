/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.clanworldboss.event;

import lombok.Value;

/**
 * @author YY
 *
 */
@Value(staticConstructor = "of")
public class ClanWorldBossEndEvent {
	private long clanId;
	private int rank;
	private long point;
}
