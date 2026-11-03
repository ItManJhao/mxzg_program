package com.ayjs.mxzg.config.excel.cache.promotion;


import java.util.Map;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion027Adventure;

@Component
public class Promotion027AdventureSysCache extends BaseExcelCache<CPromotion027Adventure> implements ILoopingPromotionCache {

	private Map<Integer, Map<Integer, CPromotion027Adventure>> turnsIdxMap;
	
	private int maxTurns;
	
	@Override
	public String getFileName() {
		return "promotionadventure";
	}

	@Override
	protected void loadAfterReady() {
		this.turnsIdxMap = this.fillTwoLayerMap(CPromotion027Adventure::getTurns, CPromotion027Adventure::getIdx);
		for(Integer turns : turnsIdxMap.keySet()) {
			if(turns > maxTurns) {
				maxTurns = turns;
			}
		}
	}

	public CPromotion027Adventure getByTurnsIdx(int turns, int idx) {
		Map<Integer, CPromotion027Adventure> idxMap = turnsIdxMap.get(turns);
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