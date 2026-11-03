/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.champion.event;

import java.util.Collection;

import com.ayjs.mxzg.gameserver.module.champion.domain.ChampionCompetitor;

import lombok.Value;

/**
 * @author YY
 * 冠军赛结束事件
 */
@Value(staticConstructor = "of")
public class ChampionEndEvent {
	private Collection<ChampionCompetitor> competitors;
}
