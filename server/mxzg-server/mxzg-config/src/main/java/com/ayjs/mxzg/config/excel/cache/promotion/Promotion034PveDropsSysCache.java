/**
 * 
 */
package com.ayjs.mxzg.config.excel.cache.promotion;

import java.util.Map;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion034PveDrops;

/**
 * @author YY
 *
 */
@Component
public class Promotion034PveDropsSysCache extends BaseExcelCache<CPromotion034PveDrops> {

	private Map<Integer, CPromotion034PveDrops> turnsMap;
	
	@Override
	public String getFileName() {
		return "promotionpvedrops";
	}

	@Override
	protected void loadAfterReady() {
		this.turnsMap = this.fillOneLayerMap(CPromotion034PveDrops::getTurns);
	}

	public CPromotion034PveDrops getByTurns(int turns) {
		return turnsMap.get(turns);
	}
	
}
