package com.ayjs.mxzg.config.excel.cache.promotion;

import java.util.Map;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion017DragonMarkTotalCharge;

@Component
public class Promotion017DragonMarkTotalChargeSysCache extends BaseExcelCache<CPromotion017DragonMarkTotalCharge> implements ILoopingPromotionCache {

	private Map<Integer, Map<Integer, CPromotion017DragonMarkTotalCharge>> turnsIdxMap;

	private int maxTurns;
	
	@Override
	public String getFileName() {
		return "promotiondragonmarktotalcharge";
	}

	@Override
	protected void loadAfterReady() {
		this.turnsIdxMap = this.fillTwoLayerMap(CPromotion017DragonMarkTotalCharge::getTurns,
				CPromotion017DragonMarkTotalCharge::getIdx);
		for(Integer turns : turnsIdxMap.keySet()) {
			if(turns > maxTurns) {
				maxTurns = turns;
			}
		}
	}

	public Map<Integer, CPromotion017DragonMarkTotalCharge> getTurns(int turns) {
		return turnsIdxMap.get(turns);
	}
	
	public CPromotion017DragonMarkTotalCharge getTurnsIdx(int turns, int idx) {
		Map<Integer, CPromotion017DragonMarkTotalCharge> idxMap = turnsIdxMap.get(turns);
		if (idxMap == null) {
			return null;
		}
		return idxMap.get(idx);
	}

	@Override
	public int getMaxTurns() {
		return maxTurns;
	}
}