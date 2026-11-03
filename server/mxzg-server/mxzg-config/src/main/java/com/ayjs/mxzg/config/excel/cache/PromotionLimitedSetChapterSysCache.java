package com.ayjs.mxzg.config.excel.cache;


import java.util.Map;
import java.util.function.Function;
import java.util.stream.Collectors;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CPromotionLimitedSetChapter;

@Component
public class PromotionLimitedSetChapterSysCache extends BaseExcelCache<CPromotionLimitedSetChapter> {

    private Map<Integer, CPromotionLimitedSetChapter> chapterMap;

    @Override
    public String getFileName() {
        return "promotionlimitedsetchapter";
    }


    public CPromotionLimitedSetChapter getByLevel(int missionId) {
        return chapterMap.get(missionId);
    }

	@Override
	protected void loadAfterReady() {
		chapterMap = getAll().stream().collect(Collectors.toMap(CPromotionLimitedSetChapter::getChapter, Function.identity()));
	}
}