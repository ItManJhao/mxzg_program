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
public class ClanWorldBossStageEvent {
	private int stage;
	private int nextStageTime;
}
