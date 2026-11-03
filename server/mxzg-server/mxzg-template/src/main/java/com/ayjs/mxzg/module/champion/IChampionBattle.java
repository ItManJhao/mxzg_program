/**
 * 
 */
package com.ayjs.mxzg.module.champion;

import java.util.Set;

import com.ayjs.mxzg.battle.model.mirror.BattlerVo;

/**
 * @author YY
 *
 */
public interface IChampionBattle {
	long getId();
	void setId(long id);
	int getBattleRound();
	void setBattleRound(int battleRound);
	int getKnockoutSort();
	void setKnockoutSort(int knockoutSort);
	long getAtkRid();
	void setAtkRid(long atkRid);
	long getDefRid();
	void setDefRid(long defRid);
	int getWhichWin();
	void setWhichWin(int whichWin);
	long getAtkCoin();
	void setAtkCoin(long atkCoin);
	long getDefCoin();
	void setDefCoin(long defCoin);
	Set<Long> getGuessPlayers();
	void setGuessPlayers(Set<Long> guessPlayers);
	int getAtkFight();
	void setAtkFight(int atkFight);
	int getDefFight();
	void setDefFight(int defFight);
	BattlerVo getAtkVo();
	void setAtkVo(BattlerVo atkVo);
	BattlerVo getDefVo();
	void setDefVo(BattlerVo defVo);
	String getBattleId();
	void setBattleId(String battleId);
	int getTime();
	void setTime(int time);
	String getBattleLog();
	void setBattleLog(String battleLog);
	int getPeriod();
	void setPeriod(int period);
	int getRound();
	void setRound(int round);
	int getCrossGroupId();
	void setCrossGroupId(int crossGroupId);
}
