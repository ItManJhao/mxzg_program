package com.ayjs.mxzg.config.excel.cache.promotion;

import java.util.Comparator;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion035HappyTime;

/**
 * @Author: CWJ
 * @Date: 2019/10/25
 **/
@Component
public class Promotion035HappyTimeSysCache extends BaseExcelCache<CPromotion035HappyTime> implements ILoopingPromotionCache {

    private Map<Integer, List<CPromotion035HappyTime>> map;

    private int maxTurns;

    @Override
    public void loadAfterReady() {
        map = getAll().stream().collect(Collectors.groupingBy(CPromotion035HappyTime::getTurns));
        maxTurns = this.getAll().stream().max(Comparator.comparingInt(CPromotion035HappyTime::getTurns)).get().getTurns();

    }

    public List<CPromotion035HappyTime> getConfigsByTurn(int turns) {
        return map.get(turns);
    }

    @Override
    public String getFileName() {
        return "promotionhappymonth";
    }

    @Override
    public int getMaxTurns() {
        return maxTurns;
    }
}
