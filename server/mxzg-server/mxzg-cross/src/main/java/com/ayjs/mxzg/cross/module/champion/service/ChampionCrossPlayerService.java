/**
 * 
 */
package com.ayjs.mxzg.cross.module.champion.service;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.cache.ChampionSeasonSysCache;
import com.ayjs.mxzg.config.excel.entity.CChampionSeason;
import com.ayjs.mxzg.cross.module.champion.dao.ChampionCrossPlayerDao;
import com.ayjs.mxzg.cross.module.champion.domain.ChampionCrossPlayer;
import com.ayjs.mxzg.cross.module.champion.domain.ChampionCrossSystem;

/**
 * @author YY
 *
 */
@Service
public class ChampionCrossPlayerService {

	@Autowired
	private ChampionCrossPlayerDao championPlayerDao;
	@Autowired
	private ChampionCrossService championService;
	@Autowired
	private ChampionSeasonSysCache championSeasonSysCache;
	
	
	public ChampionCrossPlayer getPlayer(long rid) {
		ChampionCrossPlayer championPlayer = championPlayerDao.get(rid);
		if(championPlayer == null) {
			championPlayer = new ChampionCrossPlayer();
			championPlayer.setRid(rid);
			championPlayer.setGuessRecords(new ArrayList<>());
			championPlayer.setKneels(new HashSet<>());
			championPlayerDao.add(championPlayer);
		}
		
		boolean needUpdate = false;
		ChampionCrossSystem championSystem = championService.getSystem();
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
	
	public void update(ChampionCrossPlayer championPlayer) {
		championPlayerDao.update(championPlayer);
	}
	public void update(List<ChampionCrossPlayer> championPlayers) {
		championPlayerDao.update(championPlayers);
	}
	
	public List<ChampionCrossPlayer> getByRound(int round) {
		return championPlayerDao.list("round", round);
	}
}
