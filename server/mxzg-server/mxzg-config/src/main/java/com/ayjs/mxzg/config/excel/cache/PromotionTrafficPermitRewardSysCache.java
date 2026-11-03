package com.ayjs.mxzg.config.excel.cache;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CPromotionTrafficPermitReward;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Component
public class PromotionTrafficPermitRewardSysCache extends BaseExcelCache<CPromotionTrafficPermitReward> {

    private int maxLevel;

    private Map<Integer, List<CPromotionTrafficPermitReward>> map;

    @Override
    public String getFileName() {
        return "promotiontrafficpermitreward";
    }

    @Override
    protected void loadAfterReady() {
        maxLevel = getAll().stream().map(CPromotionTrafficPermitReward::getLevel).max(Integer::compareTo).orElse(0);
        map = getAll().stream().collect(Collectors.groupingBy(CPromotionTrafficPermitReward::getRound));
    }

    public List<CPromotionTrafficPermitReward> getByRound(int round) {
        return map.get(round);
    }

    public int getMaxLevel() {
        return maxLevel;
    }
}
