package com.ayjs.mxzg.config.excel.cache.promotion;


import java.util.Map;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion021DailyFirstRecharge;

@Component
public class Promotion021DailyFirstRechargeSysCache extends BaseExcelCache<CPromotion021DailyFirstRecharge> implements ILoopingPromotionCache {

	//<轮数，list<数据>>
	private Map<Integer, Map<Integer, CPromotion021DailyFirstRecharge>> turnsMap;
	
	private int maxTurns;
	
	@Override
	public String getFileName() {
		return "promotiondailyfirstrecharge";
	}

	@Override
	protected void loadAfterReady() {
		this.turnsMap = this.fillTwoLayerMap(CPromotion021DailyFirstRecharge::getTurns, CPromotion021DailyFirstRecharge::getType);
		for(Integer turns : turnsMap.keySet()) {
			if(turns > maxTurns) {
				maxTurns = turns;
			}
		}
	}

	public Map<Integer, CPromotion021DailyFirstRecharge> getByTurns(int turns) {
		return turnsMap.get(turns);
	}
	
	public CPromotion021DailyFirstRecharge getByTurns(int turns, int type) {
		Map<Integer, CPromotion021DailyFirstRecharge> map = turnsMap.get(turns);
		if(map == null) {
			return null;
		}
		return map.get(type);
	}
	

	@Override
	public int getMaxTurns() {
		return maxTurns;
	}

}