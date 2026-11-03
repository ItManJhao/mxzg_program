/**
 * 
 */
package com.ayjs.mxzg.config.struct.champion;

/**
 * @author YY
 *
 */
public class ChampionGuess {
	//比赛ID
	private long bid;
	//竞猜类型，1进攻方胜利，2防守方胜利
	private int guessType;
	//投注数量
	private long guessCoin;
	//竞猜输赢变化量
	private long delta;
	public long getBid() {
		return bid;
	}
	public void setBid(long bid) {
		this.bid = bid;
	}
	public int getGuessType() {
		return guessType;
	}
	public void setGuessType(int guessType) {
		this.guessType = guessType;
	}
	public long getGuessCoin() {
		return guessCoin;
	}
	public void setGuessCoin(long guessCoin) {
		this.guessCoin = guessCoin;
	}
	public long getDelta() {
		return delta;
	}
	public void setDelta(long delta) {
		this.delta = delta;
	}
}
