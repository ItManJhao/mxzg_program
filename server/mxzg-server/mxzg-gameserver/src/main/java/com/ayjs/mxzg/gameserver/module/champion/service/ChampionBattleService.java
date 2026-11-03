/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.champion.service;

import java.util.HashSet;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ayjs.mxzg.gameserver.module.champion.dao.ChampionBattleDao;
import com.ayjs.mxzg.gameserver.module.champion.domain.ChampionBattle;
import com.ayjs.mxzg.gameserver.module.champion.domain.ChampionSystem;
import com.ayjs.mxzg.module.champion.IChampionCompetitor;

/**
 * @author YY
 *
 */
@Service
public class ChampionBattleService {

	@Autowired
	private ChampionBattleDao championBattleDao;
	
	
	public List<ChampionBattle> getByRound(int round) {
		return championBattleDao.list("round", round);
	}
	
	public void insertBattles(List<ChampionBattle> list) {
		championBattleDao.add(list);
	}
	
	public void updateBattles(List<ChampionBattle> list) {
		championBattleDao.update(list);
	}
	
	public void updateBattle(ChampionBattle battle) {
		championBattleDao.update(battle);
	}
	
	public ChampionBattle createTrialsBattle(ChampionSystem championSystem, IChampionCompetitor atk, IChampionCompetitor def) {
		return createBattle(championSystem, atk, def, 0);
	}
	
	public ChampionBattle createKnockoutBattle(ChampionSystem championSystem, IChampionCompetitor atk, IChampionCompetitor def, int knockoutSort) {
		return createBattle(championSystem, atk, def, knockoutSort);
	}
	
	private ChampionBattle createBattle(ChampionSystem championSystem, IChampionCompetitor atk, IChampionCompetitor def, int knockoutSort) {
		ChampionBattle battle = new ChampionBattle();
		battle.setBattleId("");
		battle.setRound(championSystem.getRound());
		battle.setPeriod(championSystem.getPeriod());
		battle.setBattleRound(championSystem.getBattleRound());

		battle.setAtkRid(atk.getRid());
		battle.setAtkFight(atk.getFighting());
		battle.setAtkVo(atk.getBattlerVo());

		battle.setDefRid(def.getRid());
		battle.setDefFight(def.getFighting());
		battle.setDefVo(def.getBattlerVo());
		
		battle.setKnockoutSort(knockoutSort);
		
		battle.setGuessPlayers(new HashSet<>());
		return battle;
	}
}
