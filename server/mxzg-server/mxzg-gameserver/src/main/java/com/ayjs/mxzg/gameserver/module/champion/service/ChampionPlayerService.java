/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.champion.service;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.cache.ChampionSeasonSysCache;
import com.ayjs.mxzg.config.excel.entity.CChampionSeason;
import com.ayjs.mxzg.gameserver.module.champion.dao.ChampionPlayerDao;
import com.ayjs.mxzg.gameserver.module.champion.domain.ChampionPlayer;
import com.ayjs.mxzg.gameserver.module.champion.domain.ChampionSystem;

/**
 * @author YY
 *
 */
@Service
public class ChampionPlayerService {

	@Autowired
	private ChampionPlayerDao championPlayerDao;
	@Autowired
	private ChampionService championService;
	@Autowired
	private ChampionSeasonSysCache championSeasonSysCache;
	
	
	public ChampionPlayer getPlayer(long rid) {
		ChampionPlayer championPlayer = championPlayerDao.get(rid);
		if(championPlayer == null) {
			championPlayer = new ChampionPlayer();
			championPlayer.setRid(rid);
			championPlayer.setDailyTime(TimeDateUtil.getTomorrowZeroTimeInt());
			championPlayer.setKneels(new HashSet<>());
			championPlayer.setGuessRecords(new ArrayList<>());
			championPlayerDao.add(championPlayer);
		}
		
		boolean needUpdate = false;
		ChampionSystem championSystem = championService.getSystem();
		if(championSystem.getRound() != championPlayer.getRound()) {
			CChampionSeason championSeason = championSeasonSysCache.getOrThrow(championSystem.getConfigId());
			championPlayer.setGuessCoin(championSeason.getGuess());
			championPlayer.setRound(championSystem.getRound());
			championPlayer.setGuessRecords(new ArrayList<>());
			needUpdate = true;
		}
		if(TimeDateUtil.getCurrentTimeInt() > championPlayer.getDailyTime()) {
			championPlayer.setDailyTime(TimeDateUtil.getTomorrowZeroTimeInt());
			championPlayer.getKneels().clear();
			needUpdate = true;
		}
		if(needUpdate) {
			championPlayerDao.update(championPlayer);
		}
		return championPlayer;
	}
	
	public void update(ChampionPlayer championPlayer) {
		championPlayerDao.update(championPlayer);
	}
	public void update(List<ChampionPlayer> championPlayers) {
		championPlayerDao.update(championPlayers);
	}
	
	public List<ChampionPlayer> getByRound(int round) {
		return championPlayerDao.list("round", round);
	}
}
