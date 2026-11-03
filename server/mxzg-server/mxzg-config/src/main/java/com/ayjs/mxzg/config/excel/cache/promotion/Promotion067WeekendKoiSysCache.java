package com.ayjs.mxzg.config.excel.cache.promotion;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.common.excel.ConfigAsserts;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion067WeekendKoi;
import org.springframework.stereotype.Component;

import java.util.Map;

@Component
public class Promotion067WeekendKoiSysCache extends BaseExcelCache<CPromotion067WeekendKoi> implements ILoopingPromotionCache {

    public Map<Integer, CPromotion067WeekendKoi> map;

    public int maxTurns;

    @Override
    protected void loadAfterReady() {
        this.map = fillOneLayerMap(CPromotion067WeekendKoi::getTurns);
        for (int turns : map.keySet()) {
            if (turns > maxTurns) {
                maxTurns = turns;
            }
        }
    }

    public CPromotion067WeekendKoi getTurnsMap(int turns) {
        CPromotion067WeekendKoi cPromotion067WeekendKoi = map.get(turns);
        ConfigAsserts.notNull(cPromotion067WeekendKoi, () -> String.format("周末锦鲤promotino067WeekendKoi数据不存在轮次{%s}", turns));
        return cPromotion067WeekendKoi;
    }

    @Override
    public String getFileName() {
        return "promotionweekendkoi";
    }

    @Override
    public int getMaxTurns() {
        return maxTurns;
    }
}
