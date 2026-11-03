/**
 * 
 */
package com.ayjs.mxzg.module.champion;

import com.ayjs.mxzg.config.struct.GameEvent;

import lombok.Value;

/**
 * @author YY
 *
 */
@Value(staticConstructor = "of")
public class ChampionGuessEvent {
	private long rid;
	private long delta;
	private long curr;
	private int guessType;
	private IChampionBattle battle;
	private GameEvent gameEvent;
}
