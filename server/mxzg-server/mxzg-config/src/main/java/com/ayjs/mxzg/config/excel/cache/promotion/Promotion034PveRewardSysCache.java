package com.ayjs.mxzg.config.excel.cache.promotion;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion034PveReward;

/**
 * 诸神之战领奖
 *
 * @Author: CWJ
 * @Date: 2019/10/18
 **/
@Component
public class Promotion034PveRewardSysCache extends BaseExcelCache<CPromotion034PveReward> {

    private Map<Integer, List<CPromotion034PveReward>> map;

    @Override
    public void loadAfterReady() {
        map = fillListMap(CPromotion034PveReward::getTurns);
    }

    @Override
    public String getFileName() {
        return "promotionpvereward";
    }

    public List<CPromotion034PveReward> getConfigsByTurn(int turns) {
        return map.get(turns);
    }
}
