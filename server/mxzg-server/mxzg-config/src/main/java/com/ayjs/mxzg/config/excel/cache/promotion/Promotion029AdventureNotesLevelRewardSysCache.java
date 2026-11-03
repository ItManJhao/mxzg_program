package com.ayjs.mxzg.config.excel.cache.promotion;


import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion029AdventureNotesLevelReward;

@Component
public class Promotion029AdventureNotesLevelRewardSysCache
		extends BaseExcelCache<CPromotion029AdventureNotesLevelReward> implements ILoopingPromotionCache {

    private Map<Integer, List<CPromotion029AdventureNotesLevelReward>> configMap;
    private int maxTurns;

    @Override
    public void loadAfterReady() {
        configMap = this.fillListMap(CPromotion029AdventureNotesLevelReward::getTurns);
        for (Integer turns : configMap.keySet()) {
            if (turns > maxTurns) {
                maxTurns = turns;
            }
        }
    }

    public List<CPromotion029AdventureNotesLevelReward> getConfigsByTurn(int turns) {
        return configMap.get(turns);
    }

    @Override
    public String getFileName() {
        return "promotionadventurenoteslevelreward";
    }

    @Override
    public int getMaxTurns() {
        return maxTurns;
    }
}