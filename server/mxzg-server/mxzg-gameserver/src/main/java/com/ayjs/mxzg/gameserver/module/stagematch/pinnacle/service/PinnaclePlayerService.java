/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.stagematch.pinnacle.service;

import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.cache.TopMatchSecondSeasonSysCache;
import com.ayjs.mxzg.config.excel.entity.CTopMatchSecondSeason;
import com.ayjs.mxzg.gameserver.module.stagematch.pinnacle.dao.PinnaclePlayerDao;
import com.ayjs.mxzg.gameserver.module.stagematch.pinnacle.domain.PinnaclePlayer;
import com.ayjs.mxzg.gameserver.module.stagematch.pinnacle.domain.PinnacleSystem;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;


@Service
public class PinnaclePlayerService {

	@Autowired
	private PinnaclePlayerDao pinnaclePlayerDao;
	@Autowired
	private PinnacleService pinnacleService;
	@Autowired
	private TopMatchSecondSeasonSysCache pinnacleSeasonSysCache;
	
	
	public PinnaclePlayer getPlayer(long rid) {
		PinnaclePlayer pinnaclePlayer = pinnaclePlayerDao.get(rid);
		if(pinnaclePlayer == null) {
			pinnaclePlayer = new PinnaclePlayer();
			pinnaclePlayer.setRid(rid);
			pinnaclePlayer.setDailyTime(TimeDateUtil.getTomorrowZeroTimeInt());
			pinnaclePlayer.setKneels(new HashSet<>());
			pinnaclePlayer.setGuessRecords(new ArrayList<>());
			pinnaclePlayerDao.add(pinnaclePlayer);
		}
		
		boolean needUpdate = false;
		PinnacleSystem pinnacleSystem = pinnacleService.getSystem();
		if(pinnacleSystem.getRound() != pinnaclePlayer.getRound()) {
			CTopMatchSecondSeason pinnacleSeason = pinnacleSeasonSysCache.getCrossSeason();
			pinnaclePlayer.setGuessCoin(pinnacleSeason.getGuess());
			pinnaclePlayer.setRound(pinnacleSystem.getRound());
			pinnaclePlayer.setGuessRecords(new ArrayList<>());
			needUpdate = true;
		}
		if(TimeDateUtil.getCurrentTimeInt() > pinnaclePlayer.getDailyTime()) {
			pinnaclePlayer.setDailyTime(TimeDateUtil.getTomorrowZeroTimeInt());
			pinnaclePlayer.getKneels().clear();
			needUpdate = true;
		}
		if(needUpdate) {
			pinnaclePlayerDao.update(pinnaclePlayer);
		}
		return pinnaclePlayer;
	}
	
	public void update(PinnaclePlayer pinnaclePlayer) {
		pinnaclePlayerDao.update(pinnaclePlayer);
	}
	public void update(List<PinnaclePlayer> pinnaclePlayers) {
		pinnaclePlayerDao.update(pinnaclePlayers);
	}
	
	public List<PinnaclePlayer> getByRound(int round) {
		return pinnaclePlayerDao.list("round", round);
	}
}
