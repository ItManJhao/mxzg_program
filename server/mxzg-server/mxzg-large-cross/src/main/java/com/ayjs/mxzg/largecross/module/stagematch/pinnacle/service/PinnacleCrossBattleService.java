/**
 * 
 */
package com.ayjs.mxzg.largecross.module.stagematch.pinnacle.service;

import com.ayjs.mxzg.largecross.module.stagematch.pinnacle.dao.PinnacleCrossBattleDao;
import com.ayjs.mxzg.largecross.module.stagematch.pinnacle.domain.PinnacleCrossBattle;
import com.ayjs.mxzg.largecross.module.stagematch.pinnacle.domain.PinnacleCrossSystem;
import com.ayjs.mxzg.module.pinnacle.IPinnacleCompetitor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;


@Service
public class PinnacleCrossBattleService {

	@Autowired
	private PinnacleCrossBattleDao pinnacleCrossBattleDao;
	
	/**
	 * 正在进行的比赛列表
	 */
	private List<PinnacleCrossBattle> runningBattle;
	/**
	 * 本届所有比赛的缓存
	 */
	private Map<Long, PinnacleCrossBattle> allBattleMap = new ConcurrentHashMap<>();

	public List<PinnacleCrossBattle> getByRound(int round) {
		return pinnacleCrossBattleDao.list("round", round);
	}

	public void updateBattles(List<PinnacleCrossBattle> list) {
		pinnacleCrossBattleDao.update(list);
	}

	public void updateBattle(PinnacleCrossBattle battle) {
		pinnacleCrossBattleDao.update(battle);
	}

	public PinnacleCrossBattle createTrialsBattle(PinnacleCrossSystem pinnacleSystem, IPinnacleCompetitor atk,
												  IPinnacleCompetitor def) {
		return createBattle(pinnacleSystem, atk, def, 0);
	}

	public PinnacleCrossBattle createKnockoutBattle(PinnacleCrossSystem pinnacleSystem, IPinnacleCompetitor atk,
			IPinnacleCompetitor def, int knockoutSort) {
		return createBattle(pinnacleSystem, atk, def, knockoutSort);
	}

	private PinnacleCrossBattle createBattle(PinnacleCrossSystem pinnacleSystem, IPinnacleCompetitor atk,
			IPinnacleCompetitor def, int knockoutSort) {
		PinnacleCrossBattle battle = new PinnacleCrossBattle();
		battle.setBattleId("");
		battle.setRound(pinnacleSystem.getRound());
		battle.setPeriod(pinnacleSystem.getPeriod());
		battle.setBattleRound(pinnacleSystem.getBattleRound());

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
	
	public List<PinnacleCrossBattle> getRunningBattle() {
		return runningBattle;
	}

	public void setRunningBattle(List<PinnacleCrossBattle> runningBattle) {
		pinnacleCrossBattleDao.add(runningBattle);
		this.runningBattle = runningBattle;
		for(PinnacleCrossBattle battle : runningBattle) {
			this.allBattleMap.put(battle.getId(), battle);
		}
	}
	
	public List<PinnacleCrossBattle> loadOnServerStart(PinnacleCrossSystem pinnacleSystem) {
		List<PinnacleCrossBattle> battleList = this.getByRound(pinnacleSystem.getRound());
		
		List<PinnacleCrossBattle> runningList = new ArrayList<>();
		for(PinnacleCrossBattle pinnacleBattle : battleList) {
			if (pinnacleBattle.getPeriod() == pinnacleSystem.getPeriod()
					&& pinnacleBattle.getBattleRound() == pinnacleSystem.getBattleRound()) {
				runningList.add(pinnacleBattle);
			}
		}
		this.runningBattle = runningList;
		for(PinnacleCrossBattle battle : battleList) {
			this.allBattleMap.put(battle.getId(), battle);
		}
		return battleList;
	}
	
	/**
	 * 获取玩家当前正在进行的战斗
	 */
	public PinnacleCrossBattle getMyBattle(long rid) {
		if(runningBattle == null) {
			return null;
		}
		for(PinnacleCrossBattle battle : runningBattle) {
			if(battle.getAtkRid() == rid || battle.getDefRid() == rid) {
				return battle;
			}
		}
		return null;
	}
	
	public PinnacleCrossBattle getOneBattle(long bid) {
		return allBattleMap.get(bid);
	}
	
	public Map<Long, PinnacleCrossBattle> getAllBattleMap() {
		return allBattleMap;
	}
	
	public void restart() {
		this.allBattleMap.clear();
	}
}
