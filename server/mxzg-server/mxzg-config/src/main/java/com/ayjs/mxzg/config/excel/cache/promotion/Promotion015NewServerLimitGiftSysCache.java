/**
 * 
 */
package com.ayjs.mxzg.config.excel.cache.promotion;

import java.util.Map;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion015NewSeverLimitGift;

/**
 * @author YY
 *
 */
@Component
public class Promotion015NewServerLimitGiftSysCache extends BaseExcelCache<CPromotion015NewSeverLimitGift>
		implements ILoopingPromotionCache {

	private Map<Integer, Map<Integer, CPromotion015NewSeverLimitGift>> turnsProductionMap;
	
	private int maxTurns;

	@Override
	public String getFileName() {
		return "promotionnewseverlimitgift";
	}

	@Override
	protected void loadAfterReady() {
		this.turnsProductionMap = this.fillTwoLayerMap(CPromotion015NewSeverLimitGift::getTurns,
				CPromotion015NewSeverLimitGift::getProduction_id);
		for(Integer turns : turnsProductionMap.keySet()) {
			if(turns > maxTurns) {
				maxTurns = turns;
			}
		}
	}

	public CPromotion015NewSeverLimitGift getByTurnsProduction(int turns, int productId) {
		Map<Integer, CPromotion015NewSeverLimitGift> productionMap = turnsProductionMap.get(turns);
		if (productionMap == null) {
			return null;
		}
		return productionMap.get(productId);
	}

	@Override
	public int getMaxTurns() {
		return maxTurns;
	}
}
