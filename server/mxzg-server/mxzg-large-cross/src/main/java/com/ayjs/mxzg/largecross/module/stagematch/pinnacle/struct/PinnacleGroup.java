/**
 * 
 */
package com.ayjs.mxzg.largecross.module.stagematch.pinnacle.struct;

import com.ayjs.mxzg.config.struct.pinnacle.PinnacleTop;

import java.util.concurrent.ConcurrentMap;


public class PinnacleGroup {
	private int crossId;
	private long guessId;
	private long lastGuessId;
	private ConcurrentMap<Integer, PinnacleTop> topPlayers;
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
	public ConcurrentMap<Integer, PinnacleTop> getTopPlayers() {
		return topPlayers;
	}
	public void setTopPlayers(ConcurrentMap<Integer, PinnacleTop> topPlayers) {
		this.topPlayers = topPlayers;
	}
	public int getCrossId() {
		return crossId;
	}
	public void setCrossId(int crossId) {
		this.crossId = crossId;
	}
}
