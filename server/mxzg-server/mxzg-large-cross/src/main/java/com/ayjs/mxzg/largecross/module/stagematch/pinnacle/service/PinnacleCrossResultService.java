/**
 * 
 */
package com.ayjs.mxzg.largecross.module.stagematch.pinnacle.service;

import com.ayjs.mxzg.largecross.module.stagematch.pinnacle.dao.PinnacleCrossResultDao;
import com.ayjs.mxzg.largecross.module.stagematch.pinnacle.domain.PinnacleCrossResult;
import com.ayjs.mxzg.largecross.module.stagematch.pinnacle.struct.PinnacleTopData;
import com.ayjs.mxzg.message.module.stagematch.pinnacle.PinnacleMessage.CSPinnacleCoinResult;
import com.ayjs.mxzg.message.module.stagematch.pinnacle.PinnacleMessage.CSPinnacleRankResult;
import com.ayjs.mxzg.message.module.stagematch.pinnacle.PinnacleMessage.CSPinnacleTop;
import com.ayjs.mxzg.message.module.stagematch.pinnacle.PinnacleMessage.ResPinnacleEnd;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

/**
 * @author YY
 *
 */
@Service
public class PinnacleCrossResultService {
	@Autowired
	private PinnacleCrossResultDao championCrossResultDao;
	
	public List<PinnacleCrossResult> getNotReport() {
		return null;
	}
	
	public PinnacleCrossResult getByServerRound(int serverId, int round) {
		Map<String, Object> options = new HashMap<>();
		options.put("serverId", serverId);
		options.put("round", round);
		List<PinnacleCrossResult> results = championCrossResultDao.list(options);
		if(results.isEmpty()) {
			return null;
		} else {
			return results.get(0);
		}
	}
	
	
	public void insertResult(List<PinnacleCrossResult> results) {
		championCrossResultDao.add(results);
	}
	
	public void updateResult(PinnacleCrossResult result) {
		championCrossResultDao.update(result);
	}
	
	public ResPinnacleEnd serialResult(PinnacleCrossResult result) {
		ResPinnacleEnd.ResPinnacleEndBuilder builder = ResPinnacleEnd.builder();
		builder.serverId(result.getServerId());
		builder.round(result.getRound());
		List<CSPinnacleTop> topRanks = new ArrayList<>();
		for(PinnacleTopData topData : result.getTops()) {
			CSPinnacleTop.CSPinnacleTopBuilder model = CSPinnacleTop.builder();
			model.rid(topData.getRid());
			model.rank(topData.getRank());
			model.robot(topData.getRobot());
			topRanks.add(model.build());
		}
		builder.topRanks(topRanks);
		List<CSPinnacleRankResult> rankResult = new ArrayList<>();
		for(Entry<Long, Integer> entry : result.getRankResults().entrySet()) {
			CSPinnacleRankResult.CSPinnacleRankResultBuilder model = CSPinnacleRankResult.builder();
			model.rid(entry.getKey());
			model.rank(entry.getValue());
			rankResult.add(model.build());
		}
		builder.rankResult(rankResult);
		List<CSPinnacleCoinResult> coinResult = new ArrayList<>();
		for(Entry<Long, Long> entry : result.getCoinResults().entrySet()) {
			CSPinnacleCoinResult.CSPinnacleCoinResultBuilder model = CSPinnacleCoinResult.builder();
			model.rid(entry.getKey());
			model.coinNum(entry.getValue());
			coinResult.add(model.build());
		}
		builder.coinResult(coinResult);
		return builder.build();
	}
}
