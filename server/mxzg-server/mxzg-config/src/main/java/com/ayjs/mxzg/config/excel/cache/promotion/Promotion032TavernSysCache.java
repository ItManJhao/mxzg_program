package com.ayjs.mxzg.config.excel.cache.promotion;


import java.util.Comparator;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion032Tavern;

@Component
public class Promotion032TavernSysCache extends BaseExcelCache<CPromotion032Tavern> implements ILoopingPromotionCache {

    private int maxTurns;

    @Override
    public void loadAfterReady() {
        maxTurns = this.getAll().stream().max(Comparator.comparingInt(CPromotion032Tavern::getTurns)).get().getTurns();
    }


    @Override
    public String getFileName() {
        return "promotiontavern";
    }

	@Override
	public int getMaxTurns() {
		return maxTurns;
	}

}