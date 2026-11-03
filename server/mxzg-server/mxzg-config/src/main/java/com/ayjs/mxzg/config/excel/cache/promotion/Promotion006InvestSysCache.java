package com.ayjs.mxzg.config.excel.cache.promotion;


import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion006Invest;
import com.ayjs.mxzg.config.struct.ImmutableThing;

@Component
public class Promotion006InvestSysCache extends BaseExcelCache<CPromotion006Invest> {

	private Map<Integer, List<CPromotion006Invest>> typeDayMap;
	
	private Map<Integer, CPromotion006Invest> day0ProductionTypeMap;
	
	private int maxDay;
	
	@Override
	public String getFileName() {
		return "promotioninvest";
	}

	@Override
	protected void loadAfterReady() {
		this.typeDayMap = this.fillListMap(CPromotion006Invest::getProduction_id);
		for(List<CPromotion006Invest> list : typeDayMap.values()) {
			list.sort(Comparator.comparingInt(CPromotion006Invest::getDay));
		}
		
		Map<Integer, CPromotion006Invest> tempProductionTypeMap = new HashMap<>();
		for(CPromotion006Invest invest : this.getAll()) {
			if(invest.getDay() > maxDay) {
				maxDay = invest.getDay();
			}
			if(invest.getDay() == 0) {
				tempProductionTypeMap.put(invest.getProduction_id(), invest);
			}
		}
		this.day0ProductionTypeMap = tempProductionTypeMap;
	}
	
	public List<ImmutableThing> getByTypeDay(int type, int receiveDay, int reachDay) {
		List<CPromotion006Invest> list = typeDayMap.get(type);
		if(list == null) {
			return null;
		}
		List<ImmutableThing> rewardList = new ArrayList<>();
		for(CPromotion006Invest invest : list) {
			if(receiveDay < invest.getDay() && invest.getDay() <= reachDay) {
				rewardList.addAll(invest.getReward());
			}
		}
		return rewardList;
	}
	
	public CPromotion006Invest getDay0(int productionId) {
		return day0ProductionTypeMap.get(productionId);
	}

	public int getMaxDay() {
		return maxDay;
	}
}