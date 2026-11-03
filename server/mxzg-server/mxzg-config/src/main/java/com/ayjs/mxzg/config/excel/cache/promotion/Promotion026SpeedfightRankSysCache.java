package com.ayjs.mxzg.config.excel.cache.promotion;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion026SpeedFightRank;

@Component
public class Promotion026SpeedfightRankSysCache extends BaseExcelCache<CPromotion026SpeedFightRank> {

	private Map<Integer, List<CPromotion026SpeedFightRank>> turnsMap;

	@Override
	public String getFileName() {
		return "promotionspeedfightrank";
	}

	@Override
	protected void loadAfterReady() {
		this.turnsMap = this.fillListMap(CPromotion026SpeedFightRank::getTurns);
	}

	public CPromotion026SpeedFightRank getByTurnsRank(int turns, int rank) {
		List<CPromotion026SpeedFightRank> list = turnsMap.get(turns);
		if (list == null) {
			return null;
		}
		for (CPromotion026SpeedFightRank config : list) {
			if (config.getRank_low() <= rank && (config.getRank_up() == 0 || rank <= config.getRank_up())) {
				return config;
			}
		}
		return null;
	}
}