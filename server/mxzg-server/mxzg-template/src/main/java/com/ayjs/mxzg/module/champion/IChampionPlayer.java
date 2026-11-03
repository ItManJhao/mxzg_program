/**
 * 
 */
package com.ayjs.mxzg.module.champion;

import java.util.List;

import com.ayjs.mxzg.config.struct.champion.ChampionGuess;
import com.ayjs.mxzg.config.struct.champion.ChampionResult;

/**
 * @author YY
 *
 */
public interface IChampionPlayer {
	public long getRid();
	public void setRid(long rid);
	public int getRound();
	public void setRound(int round);;
	public long getGuessId();
	public void setGuessId(long guessId);
	public long getGuessCoin();
	public void setGuessCoin(long guessCoin);
	public int getGuessType();
	public void setGuessType(int guessType);
	public long getBetCoin();
	public void setBetCoin(long betCoin);
	public List<ChampionGuess> getGuessRecords();
	public void setGuessRecords(List<ChampionGuess> guessRecords);
	public int getShowRound();
	public void setShowRound(int showRound);
	public ChampionResult getResult();
	public void setResult(ChampionResult result);
	public int getShowResult();
	public void setShowResult(int showResult);
	public int getBiuCd();
	public void setBiuCd(int biuCd);
	public int getHisRank();
	public void setHisRank(int hisRank);
}
