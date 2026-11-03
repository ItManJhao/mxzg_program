package com.ayjs.mxzg.config.excel.cache.promotion;


import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion030MysteryBoxRechargeReward;

@Component
public class Promotion030MysteryBoxRechargeRewardSysCache extends BaseExcelCache<CPromotion030MysteryBoxRechargeReward> implements ILoopingPromotionCache {

    private Map<Integer, List<CPromotion030MysteryBoxRechargeReward>> configMap;

    private int maxTurns;

    @Override
    public int getMaxTurns() {
        return maxTurns;
    }

    @Override
    public void loadAfterReady() {
        configMap = this.fillListMap(CPromotion030MysteryBoxRechargeReward::getTurns);
        for (Integer turns : configMap.keySet()) {
            if (turns > maxTurns) {
                maxTurns = turns;
            }
        }
    }

    public List<CPromotion030MysteryBoxRechargeReward> getConfigsByTurn(int turns) {
        return configMap.get(turns);
    }

    @Override
    public String getFileName() {
        return "promotionmysteryboxrechargereward";
    }

}