/**
 * 
 */
package com.ayjs.mxzg.cross.module.champion.struct;

import java.util.concurrent.ConcurrentMap;

import com.ayjs.mxzg.config.struct.champion.ChampionTop;

/**
 * @author YY
 *
 */
public class ChampionGroup {
	private int crossId;
	private long guessId;
	private long lastGuessId;
	private ConcurrentMap<Integer, ChampionTop> topPlayers;
	public long getGuessId() {
		return guessId;
	}
	public void setGuessId(long guessId) {
		this.guessId = guessId;
	}
	public long getLastGuessId() {
		return lastGuessId;
	}
	public void setLastGuessId(long lastGuessId) {
		this.lastGuessId = lastGuessId;
	}
	public ConcurrentMap<Integer, ChampionTop> getTopPlayers() {
		return topPlayers;
	}
	public void setTopPlayers(ConcurrentMap<Integer, ChampionTop> topPlayers) {
		this.topPlayers = topPlayers;
	}
	public int getCrossId() {
		return crossId;
	}
	public void setCrossId(int crossId) {
		this.crossId = crossId;
	}
}
