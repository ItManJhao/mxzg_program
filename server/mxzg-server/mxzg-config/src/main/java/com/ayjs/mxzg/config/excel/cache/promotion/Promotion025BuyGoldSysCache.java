package com.ayjs.mxzg.config.excel.cache.promotion;


import java.util.Map;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion025BuyGold;

@Component
public class Promotion025BuyGoldSysCache extends BaseExcelCache<CPromotion025BuyGold> implements ILoopingPromotionCache {

	private Map<Integer, Map<Integer, CPromotion025BuyGold>> turnsIdxMap;

	private int maxTurns;
	
	@Override
	public String getFileName() {
		return "promotionbuygold";
	}

	@Override
	protected void loadAfterReady() {
		this.turnsIdxMap = this.fillTwoLayerMap(CPromotion025BuyGold::getTurns, CPromotion025BuyGold::getIdx);
		for(Integer turns : turnsIdxMap.keySet()) {
			if(turns > maxTurns) {
				maxTurns = turns;
			}
		}
	}

	public CPromotion025BuyGold getByTurnsIdx(int turns, int idx) {
		Map<Integer, CPromotion025BuyGold> idxMap = turnsIdxMap.get(turns);
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