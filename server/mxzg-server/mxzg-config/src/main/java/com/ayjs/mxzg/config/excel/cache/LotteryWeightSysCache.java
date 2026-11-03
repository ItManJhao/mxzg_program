package com.ayjs.mxzg.config.excel.cache;


import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CLotteryWeight;

@Component
public class LotteryWeightSysCache extends BaseExcelCache<CLotteryWeight> {

	@Autowired
	private HeroTypeSysCache heroTypeSysCache;

	private Map<Integer, List<CLotteryWeight>> starMap;
	private Map<Integer, CLotteryWeight> typeMap;
	
	@Override
	public String getFileName() {
		return "lotteryweight";
	}

	@Override
	protected void loadAfterReady() {
		this.starMap = this.fillListMap(CLotteryWeight::getStar);
		this.typeMap = this.fillOneLayerMap(CLotteryWeight::getHero_type);
	}

	public List<CLotteryWeight> getByStar(int star) {
		return starMap.get(star);
	}
	
	public CLotteryWeight getByType(int type) {
		return typeMap.get(type);
	}

	@Override
	public boolean check(CLotteryWeight t) {
		heroTypeSysCache.getOrThrow(t.getHero_type());
		return true;
	}
}