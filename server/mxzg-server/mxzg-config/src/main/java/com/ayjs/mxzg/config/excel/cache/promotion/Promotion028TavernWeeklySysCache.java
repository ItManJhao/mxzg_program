package com.ayjs.mxzg.config.excel.cache.promotion;


import java.util.Map;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion028TavernWeekly;

@Component
public class Promotion028TavernWeeklySysCache extends BaseExcelCache<CPromotion028TavernWeekly> implements ILoopingPromotionCache {

	private Map<Integer, Map<Integer, CPromotion028TavernWeekly>> turnsIdxMap;
	
	private int maxTurns;
	
	@Override
	public String getFileName() {
		return "promotiontavernweekly";
	}
	
	@Override
	protected void loadAfterReady() {
		this.turnsIdxMap = this.fillTwoLayerMap(CPromotion028TavernWeekly::getTurns, CPromotion028TavernWeekly::getIdx);
		for(Integer turns : turnsIdxMap.keySet()) {
			if(turns > maxTurns) {
				maxTurns = turns;
			}
		}
	}

	public CPromotion028TavernWeekly getByTurnsIdx(int turns, int idx) {
		Map<Integer, CPromotion028TavernWeekly> idxMap = turnsIdxMap.get(turns);
		if(idxMap == null) {
			return null;
		}
		return idxMap.get(idx);
	}

	@Override
	public int getMaxTurns() {
		return maxTurns;
	}
}