package com.ayjs.mxzg.config.excel.cache.promotion;


import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion029AdventureNotes;

@Component
public class Promotion029AdventureNotesSysCache extends BaseExcelCache<CPromotion029AdventureNotes> implements ILoopingPromotionCache {

    private Map<Integer, List<CPromotion029AdventureNotes>> configMap;
    private int maxTurns;

    @Override
    public void loadAfterReady() {
        configMap = this.fillListMap(CPromotion029AdventureNotes::getTurns);
        for (Integer turns : configMap.keySet()) {
            if (turns > maxTurns) {
                maxTurns = turns;
            }
        }
    }

    public List<CPromotion029AdventureNotes> getConfigsByTurn(int turns) {
        return configMap.get(turns);
    }

    @Override
    public String getFileName() {
        return "promotionadventurenotes";
    }

    @Override
    public int getMaxTurns() {
        return maxTurns;
    }
}