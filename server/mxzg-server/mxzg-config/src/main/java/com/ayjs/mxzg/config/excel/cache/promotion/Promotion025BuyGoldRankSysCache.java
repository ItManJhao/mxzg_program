package com.ayjs.mxzg.config.excel.cache.promotion;


import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion025BuyGoldRank;

@Component
public class Promotion025BuyGoldRankSysCache extends BaseExcelCache<CPromotion025BuyGoldRank> {

	private Map<Integer, List<CPromotion025BuyGoldRank>> turnsMap;

	@Override
	public String getFileName() {
		return "promotionbuygoldrank";
	}

	@Override
	protected void loadAfterReady() {
		this.turnsMap = this.fillListMap(CPromotion025BuyGoldRank::getTurns);
	}
	
	public CPromotion025BuyGoldRank getByTurnsRank(int turns, int rank) {
		List<CPromotion025BuyGoldRank> list = turnsMap.get(turns);
		if (list == null) {
			return null;
		}
		for (CPromotion025BuyGoldRank config : list) {
			if (config.getRank_low() <= rank && rank <= config.getRank_up()) {
				return config;
			}
		}
		return null;
	}

}