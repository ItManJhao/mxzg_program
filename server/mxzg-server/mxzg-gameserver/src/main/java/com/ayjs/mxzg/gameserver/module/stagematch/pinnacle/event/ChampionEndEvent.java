/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.stagematch.pinnacle.event;

import com.ayjs.mxzg.gameserver.module.champion.domain.ChampionCompetitor;
import lombok.Value;

import java.util.Collection;


@Value(staticConstructor = "of")
public class ChampionEndEvent {
	private Collection<ChampionCompetitor> competitors;
}
