/**
 * 
 */
package com.ayjs.mxzg.module.pinnacle;

import com.ayjs.mxzg.config.struct.pinnacle.PinnacleGuess;
import com.ayjs.mxzg.config.struct.pinnacle.PinnacleResult;

import java.util.List;


public interface IPinnaclePlayer {
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
	public List<PinnacleGuess> getGuessRecords();
	public void setGuessRecords(List<PinnacleGuess> guessRecords);
	public int getShowRound();
	public void setShowRound(int showRound);
	public PinnacleResult getResult();
	public void setResult(PinnacleResult result);
	public int getShowResult();
	public void setShowResult(int showResult);
	public int getBiuCd();
	public void setBiuCd(int biuCd);
	public int getHisRank();
	public void setHisRank(int hisRank);
}
