package com.ayjs.mxzg.config.excel.cache.promotion;


import java.util.Map;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion026SpeedFight;

@Component
public class Promotion026SpeedfightSysCache extends BaseExcelCache<CPromotion026SpeedFight> implements ILoopingPromotionCache {

	private Map<Integer, Map<Integer, CPromotion026SpeedFight>> turnsIdxMap;

	private int maxTurns;
	
	@Override
	public String getFileName() {
		return "promotionspeedfight";
	}

	@Override
	protected void loadAfterReady() {
		this.turnsIdxMap = this.fillTwoLayerMap(CPromotion026SpeedFight::getTurns, CPromotion026SpeedFight::getIdx);
		for(Integer turns : turnsIdxMap.keySet()) {
			if(turns > maxTurns) {
				maxTurns = turns;
			}
		}
	}

	public CPromotion026SpeedFight getByTurnsIdx(int turns, int idx) {
		Map<Integer, CPromotion026SpeedFight> idxMap = turnsIdxMap.get(turns);
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