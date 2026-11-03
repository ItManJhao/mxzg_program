/**
 * 
 */
package com.ayjs.mxzg.config.excel.cache.promotion;

import java.util.Map;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion020DailyGift;

/**
 * @author YY
 *
 */
@Component
public class Promotion020DailyGiftSysCache extends BaseExcelCache<CPromotion020DailyGift> implements ILoopingPromotionCache {

	private Map<Integer, Map<Integer, CPromotion020DailyGift>> turnsProductionMap;
	
	private int maxTurns;
	
	@Override
	public String getFileName() {
		return "promotiondailygift";
	}
	
	@Override
	protected void loadAfterReady() {
		this.turnsProductionMap = this.fillTwoLayerMap(CPromotion020DailyGift::getTurns,
				CPromotion020DailyGift::getProduction_id);
		for(Integer turns : turnsProductionMap.keySet()) {
			if(turns > maxTurns) {
				maxTurns = turns;
			}
		}
	}
	
	public CPromotion020DailyGift getByTurnsProduction(int turns, int productId) {
		Map<Integer, CPromotion020DailyGift> productionMap = turnsProductionMap.get(turns);
		if(productionMap == null) {
			return null;
		}
		return productionMap.get(productId);
	}

	@Override
	public int getMaxTurns() {
		return maxTurns;
	}
}
