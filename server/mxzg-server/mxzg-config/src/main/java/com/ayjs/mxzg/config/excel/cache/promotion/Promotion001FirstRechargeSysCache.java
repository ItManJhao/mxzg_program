package com.ayjs.mxzg.config.excel.cache.promotion;


import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion001FirstRecharge;

@Component
public class Promotion001FirstRechargeSysCache extends BaseExcelCache<CPromotion001FirstRecharge> {


	private Map<Integer, Integer> productTypeMap;
	
	private Map<Integer, CPromotion001FirstRecharge> dayOneMap;
	
	private Map<Integer, List<CPromotion001FirstRecharge>> typeDayMap;
	
	@Override
	public String getFileName() {
		return "promotionfirstrecharge";
	}

	@Override
	protected void loadAfterReady() {
		Map<Integer, Integer> tempTypeProductMap = new HashMap<>();
		
		Map<Integer, CPromotion001FirstRecharge> tempDayOneMap = new HashMap<>();
		for(CPromotion001FirstRecharge config : this.getAll()) {
			tempTypeProductMap.put(config.getProduct_id(), config.getType());
			
			if(config.getDay() == 1) {
				tempDayOneMap.put(config.getProduct_id(), config);
			}
		}
		productTypeMap = tempTypeProductMap;
		dayOneMap = tempDayOneMap;
		
		this.typeDayMap = this.fillListMap(CPromotion001FirstRecharge::getType);
	}

	public Integer getType(int productId) {
		return productTypeMap.get(productId);
	}
	
	public CPromotion001FirstRecharge getDayOne(int productId) {
		return dayOneMap.get(productId);
	}

	public List<CPromotion001FirstRecharge> getDaysReward(int type) {
		return typeDayMap.get(type);
	}
}
