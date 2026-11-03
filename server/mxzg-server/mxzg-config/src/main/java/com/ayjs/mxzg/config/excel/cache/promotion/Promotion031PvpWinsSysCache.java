package com.ayjs.mxzg.config.excel.cache.promotion;


import java.util.Comparator;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion031PvpWins;

@Component
public class Promotion031PvpWinsSysCache extends BaseExcelCache<CPromotion031PvpWins> implements ILoopingPromotionCache {

    private int maxTurns;

    @Override
    public void loadAfterReady() {
        maxTurns = this.getAll().stream().max(Comparator.comparingInt(CPromotion031PvpWins::getTurns)).get().getTurns();
    }

    @Override
    public String getFileName() {
        return "promotionpvpwins";
    }

    @Override
    public int getMaxTurns() {
        return maxTurns;
    }

}