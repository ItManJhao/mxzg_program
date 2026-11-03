package com.ayjs.mxzg.config.excel.cache.promotion;


import java.util.Map;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion016DragonMarkShops;

@Component
public class Promotion016DragonMarkShopsSysCache extends BaseExcelCache<CPromotion016DragonMarkShops> {

	private Map<Integer, Map<Integer, CPromotion016DragonMarkShops>> turnsIdxMap;
	
	@Override
	public String getFileName() {
		return "promotiondragonmarkshops";
	}

	@Override
	protected void loadAfterReady() {
		this.turnsIdxMap = this.fillTwoLayerMap(CPromotion016DragonMarkShops::getTurns, CPromotion016DragonMarkShops::getIdx);
	}
	
	public CPromotion016DragonMarkShops getTurnsIdx(int turns, int idx) {
		Map<Integer, CPromotion016DragonMarkShops> idxMap = turnsIdxMap.get(turns);
		if(idxMap == null) {
			return null;
		}
		return idxMap.get(idx);
	}
}