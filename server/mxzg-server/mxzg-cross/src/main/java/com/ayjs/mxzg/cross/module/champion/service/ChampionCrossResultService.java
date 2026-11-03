/**
 * 
 */
package com.ayjs.mxzg.cross.module.champion.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ayjs.mxzg.cross.module.champion.dao.ChampionCrossResultDao;
import com.ayjs.mxzg.cross.module.champion.domain.ChampionCrossResult;
import com.ayjs.mxzg.cross.module.champion.struct.ChampionTopData;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.CSChampionCoinResult;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.CSChampionCoinResult.CSChampionCoinResultBuilder;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.CSChampionRankResult;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.CSChampionRankResult.CSChampionRankResultBuilder;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.CSChampionTop;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.CSChampionTop.CSChampionTopBuilder;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.ResChampionEnd;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.ResChampionEnd.ResChampionEndBuilder;

/**
 * @author YY
 *
 */
@Service
public class ChampionCrossResultService {
	@Autowired
	private ChampionCrossResultDao championCrossResultDao;
	
	public List<ChampionCrossResult> getNotReport() {
		return null;
	}
	
	public ChampionCrossResult getByServerRound(int serverId, int round) {
		Map<String, Object> options = new HashMap<>();
		options.put("serverId", serverId);
		options.put("round", round);
		List<ChampionCrossResult> results = championCrossResultDao.list(options);
		if(results.isEmpty()) {
			return null;
		} else {
			return results.get(0);
		}
	}
	
	
	public void insertResult(List<ChampionCrossResult> results) {
		championCrossResultDao.add(results);
	}
	
	public void updateResult(ChampionCrossResult result) {
		championCrossResultDao.update(result);
	}
	
	public ResChampionEnd serialResult(ChampionCrossResult result) {
		ResChampionEndBuilder builder = ResChampionEnd.builder();
		builder.serverId(result.getServerId());
		builder.round(result.getRound());
		List<CSChampionTop> topRanks = new ArrayList<>();
		for(ChampionTopData topData : result.getTops()) {
			CSChampionTopBuilder model = CSChampionTop.builder();
			model.rid(topData.getRid());
			model.rank(topData.getRank());
			model.robot(topData.getRobot());
			topRanks.add(model.build());
		}
		builder.topRanks(topRanks);
		List<CSChampionRankResult> rankResult = new ArrayList<>();
		for(Entry<Long, Integer> entry : result.getRankResults().entrySet()) {
			CSChampionRankResultBuilder model = CSChampionRankResult.builder();
			model.rid(entry.getKey());
			model.rank(entry.getValue());
			rankResult.add(model.build());
		}
		builder.rankResult(rankResult);
		List<CSChampionCoinResult> coinResult = new ArrayList<>();
		for(Entry<Long, Long> entry : result.getCoinResults().entrySet()) {
			CSChampionCoinResultBuilder model = CSChampionCoinResult.builder();
			model.rid(entry.getKey());
			model.coinNum(entry.getValue());
			coinResult.add(model.build());
		}
		builder.coinResult(coinResult);
		return builder.build();
	}
}
