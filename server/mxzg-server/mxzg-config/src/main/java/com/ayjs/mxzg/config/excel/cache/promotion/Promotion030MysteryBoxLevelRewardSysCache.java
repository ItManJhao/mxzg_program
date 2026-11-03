package com.ayjs.mxzg.config.excel.cache.promotion;


import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion030MysteryBoxLevelReward;

@Component
public class Promotion030MysteryBoxLevelRewardSysCache extends BaseExcelCache<CPromotion030MysteryBoxLevelReward> implements ILoopingPromotionCache {

    private Map<Integer, List<CPromotion030MysteryBoxLevelReward>> configMap;
    private int maxTurns;

    @Override
    public void loadAfterReady() {
        configMap = this.fillListMap(CPromotion030MysteryBoxLevelReward::getTurns);
        for (Integer turns : configMap.keySet()) {
            if (turns > maxTurns) {
                maxTurns = turns;
            }
        }
    }

    public List<CPromotion030MysteryBoxLevelReward> getConfigsByTurn(int turns) {
        return configMap.get(turns);
    }

    @Override
    public String getFileName() {
        return "promotionmysteryboxlevelreward";
    }

    @Override
    public int getMaxTurns() {
        return maxTurns;
    }
}