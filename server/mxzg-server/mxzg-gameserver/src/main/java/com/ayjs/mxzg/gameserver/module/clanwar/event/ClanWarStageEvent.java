/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.clanwar.event;

import java.util.Collection;

import lombok.Value;

/**
 * @author YY
 *
 */
@Value(staticConstructor = "of")
public class ClanWarStageEvent {
	private Collection<Long> clanIds;
	private int stage;
}
