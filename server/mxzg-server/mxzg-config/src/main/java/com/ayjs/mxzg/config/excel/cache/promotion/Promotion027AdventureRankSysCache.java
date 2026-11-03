package com.ayjs.mxzg.config.excel.cache.promotion;


import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion027AdventureRank;

@Component
public class Promotion027AdventureRankSysCache extends BaseExcelCache<CPromotion027AdventureRank> {

	private Map<Integer, List<CPromotion027AdventureRank>> turnsMap;

	@Override
	public String getFileName() {
		return "promotionadventurerank";
	}

	@Override
	protected void loadAfterReady() {
		this.turnsMap = this.fillListMap(CPromotion027AdventureRank::getTurns);
	}

	public CPromotion027AdventureRank getByTurnsRank(int turns, int rank) {
		List<CPromotion027AdventureRank> list = turnsMap.get(turns);
		if (list == null) {
			return null;
		}
		for (CPromotion027AdventureRank config : list) {
			if (config.getRank_low() <= rank && (config.getRank_up() == 0 || rank <= config.getRank_up())) {
				return config;
			}
		}
		return null;
	}
}