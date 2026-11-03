package com.ayjs.mxzg.config.excel.cache;


import java.util.Map;
import java.util.function.Function;
import java.util.stream.Collectors;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CPromotionLimitedSetGodRelic;

@Component
public class PromotionLimitedSetGodRelicSysCache extends BaseExcelCache<CPromotionLimitedSetGodRelic> {

    private Map<Integer, CPromotionLimitedSetGodRelic> chapterMap;

    @Override
    public String getFileName() {
        return "promotionlimitedsetgodrelic";
    }


    public CPromotionLimitedSetGodRelic getByGodRelic(int godRelicId) {
        return chapterMap.get(godRelicId);
    }

	@Override
	protected void loadAfterReady() {
		chapterMap = getAll().stream().collect(Collectors.toMap(CPromotionLimitedSetGodRelic::getGod_relic_id, Function.identity()));
	}
}