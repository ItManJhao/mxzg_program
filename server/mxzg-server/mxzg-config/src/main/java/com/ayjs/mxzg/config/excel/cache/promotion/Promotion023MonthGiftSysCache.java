/**
 * 
 */
package com.ayjs.mxzg.config.excel.cache.promotion;

import java.util.Map;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion023MonthGift;

/**
 * @author YY
 *
 */
@Component
public class Promotion023MonthGiftSysCache extends BaseExcelCache<CPromotion023MonthGift> implements ILoopingPromotionCache {

	private Map<Integer, Map<Integer, CPromotion023MonthGift>> turnsProductionMap;
	
	private int maxTurns;
	
	@Override
	public String getFileName() {
		return "promotionmonthgift";
	}

	@Override
	protected void loadAfterReady() {
		this.turnsProductionMap = this.fillTwoLayerMap(CPromotion023MonthGift::getTurns, CPromotion023MonthGift::getProduction_id);
		for(Integer turns : turnsProductionMap.keySet()) {
			if(turns > maxTurns) {
				maxTurns = turns;
			}
		}
	}
	
	public CPromotion023MonthGift getByTurnsProduction(int turns, int productId) {
		Map<Integer, CPromotion023MonthGift> idxMap = turnsProductionMap.get(turns);
		if(idxMap == null) {
			return null;
		}
		return idxMap.get(productId);
	}

	@Override
	public int getMaxTurns() {
		return maxTurns;
	}
}
