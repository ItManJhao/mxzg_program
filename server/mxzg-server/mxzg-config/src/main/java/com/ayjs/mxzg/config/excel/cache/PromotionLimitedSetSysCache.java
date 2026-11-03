package com.ayjs.mxzg.config.excel.cache;


import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CPromotionLimitedSet;

@Component
public class PromotionLimitedSetSysCache extends BaseExcelCache<CPromotionLimitedSet> {

    private Map<Integer, List<CPromotionLimitedSet>> starMap;

    public List<CPromotionLimitedSet> getByStar(int star) {
        return starMap.get(star);
    }

    @Override
    public String getFileName() {
        return "promotionlimitedset";
    }

	@Override
	protected void loadAfterReady() {
		starMap = getAll().stream().collect(Collectors.groupingBy(CPromotionLimitedSet::getStar));
	}
}