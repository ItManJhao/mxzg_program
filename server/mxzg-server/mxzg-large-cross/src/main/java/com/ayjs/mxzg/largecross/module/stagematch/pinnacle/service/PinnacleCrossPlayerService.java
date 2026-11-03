/**
 * 
 */
package com.ayjs.mxzg.largecross.module.stagematch.pinnacle.service;

import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.cache.TopMatchSecondSeasonSysCache;
import com.ayjs.mxzg.config.excel.entity.CTopMatchSecondSeason;
import com.ayjs.mxzg.largecross.module.stagematch.pinnacle.dao.PinnacleCrossPlayerDao;
import com.ayjs.mxzg.largecross.module.stagematch.pinnacle.domain.PinnacleCrossPlayer;
import com.ayjs.mxzg.largecross.module.stagematch.pinnacle.domain.PinnacleCrossSystem;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;


@Service
public class PinnacleCrossPlayerService {

	@Autowired
	private PinnacleCrossPlayerDao pinnacleCrossPlayerDao;
	@Autowired
	private PinnacleCrossService pinnacleCrossService;
	@Autowired
	private TopMatchSecondSeasonSysCache topMatchSecondSeasonSysCache;
	
	
	public PinnacleCrossPlayer getPlayer(long rid) {
		PinnacleCrossPlayer pinnacleCrossPlayer = pinnacleCrossPlayerDao.get(rid);
		if(pinnacleCrossPlayer == null) {
			pinnacleCrossPlayer = new PinnacleCrossPlayer();
			pinnacleCrossPlayer.setRid(rid);
			pinnacleCrossPlayer.setGuessRecords(new ArrayList<>());
			pinnacleCrossPlayer.setKneels(new HashSet<>());
			pinnacleCrossPlayerDao.add(pinnacleCrossPlayer);
		}
		
		boolean needUpdate = false;
		PinnacleCrossSystem system = pinnacleCrossService.getSystem();
		if(system.getRound() != pinnacleCrossPlayer.getRound()) {
			CTopMatchSecondSeason topMatchSecondSeason = topMatchSecondSeasonSysCache.getCrossSeason();
			pinnacleCrossPlayer.setGuessCoin(topMatchSecondSeason.getGuess());
			pinnacleCrossPlayer.setRound(system.getRound());
			pinnacleCrossPlayer.setGuessRecords(new ArrayList<>());
			needUpdate = true;
		}
		if(TimeDateUtil.getCurrentTimeInt() > pinnacleCrossPlayer.getDailyTime()) {
			pinnacleCrossPlayer.setDailyTime(TimeDateUtil.getTomorrowZeroTimeInt());
			pinnacleCrossPlayer.getKneels().clear();
			needUpdate = true;
		}
		if(needUpdate) {
			pinnacleCrossPlayerDao.update(pinnacleCrossPlayer);
		}
		return pinnacleCrossPlayer;
	}
	
	public void update(PinnacleCrossPlayer championPlayer) {
		pinnacleCrossPlayerDao.update(championPlayer);
	}
	public void update(List<PinnacleCrossPlayer> championPlayers) {
		pinnacleCrossPlayerDao.update(championPlayers);
	}
	
	public List<PinnacleCrossPlayer> getByRound(int round) {
		return pinnacleCrossPlayerDao.list("round", round);
	}
}
