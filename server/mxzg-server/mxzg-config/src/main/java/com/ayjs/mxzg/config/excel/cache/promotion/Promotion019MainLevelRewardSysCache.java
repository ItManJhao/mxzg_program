package com.ayjs.mxzg.config.excel.cache.promotion;


import java.util.Map;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion019MainLevelReward;

@Component
public class Promotion019MainLevelRewardSysCache extends BaseExcelCache<CPromotion019MainLevelReward> implements ILoopingPromotionCache {

	private Map<Integer, Map<Integer, CPromotion019MainLevelReward>> turnsIdxMap;

	private int maxTurns;
	
	@Override
	public String getFileName() {
		return "promotionmainlevelreward";
	}

	@Override
	protected void loadAfterReady() {
		this.turnsIdxMap = this.fillTwoLayerMap(CPromotion019MainLevelReward::getTurns,
				CPromotion019MainLevelReward::getIdx);
		for(Integer turns : turnsIdxMap.keySet()) {
			if(turns > maxTurns) {
				maxTurns = turns;
			}
		}
	}
	
	public Map<Integer, CPromotion019MainLevelReward> getTurnsReward(int turns) {
		return turnsIdxMap.get(turns);
	}

	@Override
	public int getMaxTurns() {
		return maxTurns;
	}
}