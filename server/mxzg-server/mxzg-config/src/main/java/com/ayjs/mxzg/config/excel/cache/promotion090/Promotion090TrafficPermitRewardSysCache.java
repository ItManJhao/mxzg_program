package com.ayjs.mxzg.config.excel.cache.promotion090;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.promotion090.CPromotion090TrafficPermitReward;
import org.springframework.stereotype.Component;

@Component
public class Promotion090TrafficPermitRewardSysCache extends BaseExcelCache<CPromotion090TrafficPermitReward> {

    private int maxLevel;

    @Override
    public String getFileName() {
        return "promotion090trafficpermitreward";
    }

    @Override
    protected void loadAfterReady() {
        maxLevel = getAll().stream().map(CPromotion090TrafficPermitReward::getLevel).max(Integer::compareTo).orElse(0);
    }

    public int getMaxLevel() {
        return maxLevel;
    }
}
