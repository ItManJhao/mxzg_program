package com.ayjs.mxzg.config.excel.cache.promotion;


import java.util.Comparator;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion033Combine;

@Component
public class Promotion033CombineSysCache extends BaseExcelCache<CPromotion033Combine> implements ILoopingPromotionCache {

    private int maxTurns;

    @Override
    public void loadAfterReady() {
        maxTurns = this.getAll().stream().max(Comparator.comparingInt(CPromotion033Combine::getTurns)).get().getTurns();
    }


    @Override
    public String getFileName() {
        return "promotioncombine";
    }

    @Override
    public int getMaxTurns() {
        return maxTurns;
    }


}