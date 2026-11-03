package com.ayjs.mxzg.config.excel.cache.promotion;


import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion054FlashSale;

@Component
public class Promotion054FlashSaleSysCache extends BaseExcelCache<CPromotion054FlashSale> implements ILoopingPromotionCache {

    private Map<Integer, List<CPromotion054FlashSale>> configMap;

    private int maxTurns;

    @Override
    public void loadAfterReady() {
        configMap = this.fillListMap(CPromotion054FlashSale::getTurns);
        for (Integer turns : configMap.keySet()) {
            if (turns > maxTurns) {
                maxTurns = turns;
            }
        }
    }

    public List<CPromotion054FlashSale> getConfigsByTurn(int turns) {
        return configMap.get(turns);
    }

    @Override
    public String getFileName() {
        return "promotionflashsale";
    }

    @Override
    public int getMaxTurns() {
        return maxTurns;
    }

}