package com.ayjs.mxzg.config.excel.cache;


import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CPromotionLimitedSetDay;

@Component
public class PromotionLimitedSetDaySysCache extends BaseExcelCache<CPromotionLimitedSetDay> {

    private Map<Integer, List<CPromotionLimitedSetDay>> map;

    public List<CPromotionLimitedSetDay> getByType(int type) {
        return map.get(type);
    }

    @Override
    public String getFileName() {
        return "promotionlimitedsetday";
    }

    @Override
    protected void loadAfterReady() {
        map = getAll().stream().collect(Collectors.groupingBy(CPromotionLimitedSetDay::getType));
    }

    public CPromotionLimitedSetDay getByTypeAndOpenDays(int type, int openDays) {
        return getByType(type).stream().filter(config ->
                config.getStart_day() <= openDays && config.getEnd_day() >= openDays).findFirst().orElse(null);
    }
}