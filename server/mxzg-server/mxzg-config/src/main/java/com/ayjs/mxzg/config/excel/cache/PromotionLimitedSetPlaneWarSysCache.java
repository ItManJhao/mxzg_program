package com.ayjs.mxzg.config.excel.cache;


import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CPromotionLimitedSetPlaneWar;
import org.springframework.stereotype.Component;

import java.util.Map;
import java.util.function.Function;
import java.util.stream.Collectors;

@Component
public class PromotionLimitedSetPlaneWarSysCache extends BaseExcelCache<CPromotionLimitedSetPlaneWar> {
    private Map<String, CPromotionLimitedSetPlaneWar> elementMap;

    @Override
    public String getFileName() {
        return "promotionlimitedsetplanewar";
    }

    public CPromotionLimitedSetPlaneWar getByElemAndLv(int element, int level) {
        return elementMap.get(key(element, level));
    }

    private String key(int element, int lv) {
        return String.format("%s_%s", element, lv);
    }

    @Override
    protected void loadAfterReady() {
        elementMap = getAll().stream().collect(Collectors.toMap(config -> key(config.getElement(), config.getLevel()), Function.identity()));
    }
}