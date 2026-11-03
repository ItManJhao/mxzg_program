package com.ayjs.mxzg.config.excel.cache.promotion;


import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion029AdventureNotesRechargeReward;

@Component
public class Promotion029AdventureNotesRechargeRewardSysCache extends BaseExcelCache<CPromotion029AdventureNotesRechargeReward> implements ILoopingPromotionCache {

    private Map<Integer, List<CPromotion029AdventureNotesRechargeReward>> configMap;
    private int maxTurns;

    @Override
    public void loadAfterReady() {
        configMap = this.fillListMap(CPromotion029AdventureNotesRechargeReward::getTurns);
        for (Integer turns : configMap.keySet()) {
            if (turns > maxTurns) {
                maxTurns = turns;
            }
        }
    }

    public List<CPromotion029AdventureNotesRechargeReward> getConfigsByTurn(int turns) {
        return configMap.get(turns);
    }

    @Override
    public String getFileName() {
        return "promotionadventurenotesrechargereward";
    }

    @Override
    public int getMaxTurns() {
        return maxTurns;
    }
}