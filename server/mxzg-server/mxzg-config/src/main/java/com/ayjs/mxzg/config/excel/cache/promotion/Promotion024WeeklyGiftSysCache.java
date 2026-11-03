/**
 * 
 */
package com.ayjs.mxzg.config.excel.cache.promotion;

import java.util.Map;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion024WeeklyGift;

/**
 * @author YY
 *
 */
@Component
public class Promotion024WeeklyGiftSysCache extends BaseExcelCache<CPromotion024WeeklyGift> implements ILoopingPromotionCache {

	private Map<Integer, Map<Integer, CPromotion024WeeklyGift>> turnsProductionMap;

	private int maxTurns;
	
	@Override
	public String getFileName() {
		return "promotionweeklygift";
	}

	@Override
	protected void loadAfterReady() {
		this.turnsProductionMap = this.fillTwoLayerMap(CPromotion024WeeklyGift::getTurns,
				CPromotion024WeeklyGift::getProduction_id);
		for(Integer turns : turnsProductionMap.keySet()) {
			if(turns > maxTurns) {
				maxTurns = turns;
			}
		}
	}

	public CPromotion024WeeklyGift getByTurnsProduction(int turns, int productId) {
		Map<Integer, CPromotion024WeeklyGift> idxMap = turnsProductionMap.get(turns);
		if (idxMap == null) {
			return null;
		}
		return idxMap.get(productId);
	}

	@Override
	public int getMaxTurns() {
		return maxTurns;
	}
}
