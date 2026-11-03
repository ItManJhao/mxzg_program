package com.ayjs.mxzg.config.excel.cache;


import java.util.Map;
import java.util.function.Function;
import java.util.stream.Collectors;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CPromotionLimitedSetLevel;

@Component
public class PromotionLimitedSetLevelSysCache extends BaseExcelCache<CPromotionLimitedSetLevel> {
    private Map<Integer, CPromotionLimitedSetLevel> levelMap;

    @Override
    public String getFileName() {
        return "promotionlimitedsetlevel";
    }

    public CPromotionLimitedSetLevel getByLevel(int level) {
    	return levelMap.get(level);
    }

	@Override
	protected void loadAfterReady() {
		levelMap = getAll().stream().collect(Collectors.toMap(CPromotionLimitedSetLevel::getLevel, Function.identity()));
	}
}