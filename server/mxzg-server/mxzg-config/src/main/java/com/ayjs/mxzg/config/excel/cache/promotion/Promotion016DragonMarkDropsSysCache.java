package com.ayjs.mxzg.config.excel.cache.promotion;

import java.util.Map;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion016DragonMarkDrops;

@Component
public class Promotion016DragonMarkDropsSysCache extends BaseExcelCache<CPromotion016DragonMarkDrops>
		implements ILoopingPromotionCache {

	private Map<Integer, CPromotion016DragonMarkDrops> turnsMap;

	private int maxTurns;
	
	@Override
	public String getFileName() {
		return "promotiondragonmarkdrops";
	}

	@Override
	protected void loadAfterReady() {
		this.turnsMap = this.fillOneLayerMap(CPromotion016DragonMarkDrops::getTurns);
		for(Integer turns : turnsMap.keySet()) {
			if(turns > maxTurns) {
				maxTurns = turns;
			}
		}
	}

	public CPromotion016DragonMarkDrops getByTurns(int turns) {
		return turnsMap.get(turns);
	}

	@Override
	public int getMaxTurns() {
		return maxTurns;
	}
}