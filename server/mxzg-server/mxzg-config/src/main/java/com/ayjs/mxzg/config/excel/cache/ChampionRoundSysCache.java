/**
 * 
 */
package com.ayjs.mxzg.config.excel.cache;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.common.excel.ConfigAsserts;
import com.ayjs.mxzg.common.util.ListMapUtil;
import com.ayjs.mxzg.config.excel.constant.ChampionPeriod;
import com.ayjs.mxzg.config.excel.entity.CChampionRound;

/**
 * @author YY
 *
 */
@Component
public class ChampionRoundSysCache extends BaseExcelCache<CChampionRound> {

	/**
	 * 单服配置
	 */
	private Map<Integer, Map<Integer, CChampionRound>> roundMap;
	/**
	 * 跨服配置
	 */
	private Map<Integer, Map<Integer, CChampionRound>> crossRoundMap;
	
	private int maxTrialsRound;
	
	@Override
	public String getFileName() {
		return "championround";
	}

	@Override
	protected void loadAfterReady() {
		
		Map<Integer, List<CChampionRound>> isCrossMap = this.fillListMap(CChampionRound::getIs_cross_server);
		
		this.roundMap = ListMapUtil.fillTwoLayerMap(isCrossMap.get(0), CChampionRound::getType, CChampionRound::getRound);
		
		this.crossRoundMap = ListMapUtil.fillTwoLayerMap(isCrossMap.get(1), CChampionRound::getType, CChampionRound::getRound);
		
		this.maxTrialsRound = roundMap.get(ChampionPeriod.TRIALS.getValue()).size();
	}
	
	public CChampionRound getTrialsRound(int round) {
		CChampionRound cRound = roundMap.get(ChampionPeriod.TRIALS.getValue()).get(round);
		ConfigAsserts.notNull(cRound, () -> String.format("CChampionRound选拔赛配置数据不存在{%s}", round));
		return cRound;
	}
	
	public CChampionRound getKnockoutRound(int round) {
		CChampionRound cRound = roundMap.get(ChampionPeriod.KNOCKOUT.getValue()).get(round);
		ConfigAsserts.notNull(cRound, () -> String.format("CChampionRound淘汰赛配置数据不存在{%s}", round));
		return cRound;
	}
	
	public CChampionRound getCrossTrialsRound(int round) {
		CChampionRound cRound = crossRoundMap.get(ChampionPeriod.TRIALS.getValue()).get(round);
		ConfigAsserts.notNull(cRound, () -> String.format("CChampionRound选拔赛跨服配置数据不存在{%s}", round));
		return cRound;
	}
	
	public CChampionRound getCrossKnockoutRound(int round) {
		CChampionRound cRound = crossRoundMap.get(ChampionPeriod.KNOCKOUT.getValue()).get(round);
		ConfigAsserts.notNull(cRound, () -> String.format("CChampionRound淘汰赛跨服配置数据不存在{%s}", round));
		return cRound;
	}
	

	public int getMaxTrialsRound() {
		return maxTrialsRound;
	}
}
