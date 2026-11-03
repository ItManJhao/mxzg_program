package com.ayjs.mxzg.config.excel.cache.promotion;


import java.util.Map;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion022DailyTotalRecharge;

@Component
public class Promotion022DailyTotalRechargeSysCache extends BaseExcelCache<CPromotion022DailyTotalRecharge> implements ILoopingPromotionCache {

	private Map<Integer, Map<Integer, CPromotion022DailyTotalRecharge>> turnsIdxMap;

	private int maxTurns;
	
	@Override
	public String getFileName() {
		return "promotiondailytotalrecharge";
	}

	@Override
	protected void loadAfterReady() {
		this.turnsIdxMap = this.fillTwoLayerMap(CPromotion022DailyTotalRecharge::getTurns,
				CPromotion022DailyTotalRecharge::getIdx);
		for(Integer turns : turnsIdxMap.keySet()) {
			if(turns > maxTurns) {
				maxTurns = turns;
			}
		}
	}
	
	public CPromotion022DailyTotalRecharge getByTurnsIdx(int turns, int idx) {
		Map<Integer, CPromotion022DailyTotalRecharge> idxMap = turnsIdxMap.get(turns);
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