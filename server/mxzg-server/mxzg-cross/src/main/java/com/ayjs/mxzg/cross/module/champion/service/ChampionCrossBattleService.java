/**
 * 
 */
package com.ayjs.mxzg.cross.module.champion.service;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ayjs.mxzg.cross.module.champion.dao.ChampionCrossBattleDao;
import com.ayjs.mxzg.cross.module.champion.domain.ChampionCrossBattle;
import com.ayjs.mxzg.cross.module.champion.domain.ChampionCrossSystem;
import com.ayjs.mxzg.module.champion.IChampionCompetitor;

/**
 * @author YY
 *
 */
@Service
public class ChampionCrossBattleService {

	@Autowired
	private ChampionCrossBattleDao championCrossBattleDao;
	
	/**
	 * 正在进行的比赛列表
	 */
	private List<ChampionCrossBattle> runningBattle;
	/**
	 * 本届所有比赛的缓存
	 */
	private Map<Long, ChampionCrossBattle> allBattleMap = new ConcurrentHashMap<>();

	public List<ChampionCrossBattle> getByRound(int round) {
		return championCrossBattleDao.list("round", round);
	}

	public void updateBattles(List<ChampionCrossBattle> list) {
		championCrossBattleDao.update(list);
	}

	public void updateBattle(ChampionCrossBattle battle) {
		championCrossBattleDao.update(battle);
	}

	public ChampionCrossBattle createTrialsBattle(ChampionCrossSystem championSystem, IChampionCompetitor atk,
			IChampionCompetitor def) {
		return createBattle(championSystem, atk, def, 0);
	}

	public ChampionCrossBattle createKnockoutBattle(ChampionCrossSystem championSystem, IChampionCompetitor atk,
			IChampionCompetitor def, int knockoutSort) {
		return createBattle(championSystem, atk, def, knockoutSort);
	}

	private ChampionCrossBattle createBattle(ChampionCrossSystem championSystem, IChampionCompetitor atk,
			IChampionCompetitor def, int knockoutSort) {
		ChampionCrossBattle battle = new ChampionCrossBattle();
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
		//设置跨服分组
		battle.setCrossGroupId(atk.getCrossGroup());
		return battle;
	}
	
	public List<ChampionCrossBattle> getRunningBattle() {
		return runningBattle;
	}

	public void setRunningBattle(List<ChampionCrossBattle> runningBattle) {
		championCrossBattleDao.add(runningBattle);
		this.runningBattle = runningBattle;
		for(ChampionCrossBattle battle : runningBattle) {
			this.allBattleMap.put(battle.getId(), battle);
		}
	}
	
	public List<ChampionCrossBattle> loadOnServerStart(ChampionCrossSystem championSystem) {
		List<ChampionCrossBattle> battleList = this.getByRound(championSystem.getRound());
		
		List<ChampionCrossBattle> runningList = new ArrayList<>();
		for(ChampionCrossBattle championBattle : battleList) {
			if (championBattle.getPeriod() == championSystem.getPeriod()
					&& championBattle.getBattleRound() == championSystem.getBattleRound()) {
				runningList.add(championBattle);
			}
		}
		this.runningBattle = runningList;
		for(ChampionCrossBattle battle : battleList) {
			this.allBattleMap.put(battle.getId(), battle);
		}
		return battleList;
	}
	
	/**
	 * 获取玩家当前正在进行的战斗
	 */
	public ChampionCrossBattle getMyBattle(long rid) {
		if(runningBattle == null) {
			return null;
		}
		for(ChampionCrossBattle battle : runningBattle) {
			if(battle.getAtkRid() == rid || battle.getDefRid() == rid) {
				return battle;
			}
		}
		return null;
	}
	
	public ChampionCrossBattle getOneBattle(long bid) {
		return allBattleMap.get(bid);
	}
	
	public Map<Long, ChampionCrossBattle> getAllBattleMap() {
		return allBattleMap;
	}
	
	public void restart() {
		this.allBattleMap.clear();
	}
}
