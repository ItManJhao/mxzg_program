package com.ayjs.mxzg.config.excel.cache.promotion;


import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion028TavernWeeklyRank;

@Component
public class Promotion028TavernWeeklyRankSysCache extends BaseExcelCache<CPromotion028TavernWeeklyRank> {

	private Map<Integer, List<CPromotion028TavernWeeklyRank>> turnsMap;

	@Override
	public String getFileName() {
		return "promotiontavernweeklyrank";
	}

	@Override
	protected void loadAfterReady() {
		this.turnsMap = this.fillListMap(CPromotion028TavernWeeklyRank::getTurns);
	}

	public CPromotion028TavernWeeklyRank getByTurnsRank(int turns, int rank) {
		List<CPromotion028TavernWeeklyRank> list = turnsMap.get(turns);
		if (list == null) {
			return null;
		}
		for (CPromotion028TavernWeeklyRank config : list) {
			if (config.getRank_low() <= rank && (config.getRank_up() == 0 || rank <= config.getRank_up())) {
				return config;
			}
		}
		return null;
	}
}