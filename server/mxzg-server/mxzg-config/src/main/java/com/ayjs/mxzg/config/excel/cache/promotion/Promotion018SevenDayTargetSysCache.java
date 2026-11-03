package com.ayjs.mxzg.config.excel.cache.promotion;


import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.common.excel.ConfigAsserts;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion018SevenDayTarget;

import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion029AdventureNotesLevelReward;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Map;

@Component
public class Promotion018SevenDayTargetSysCache extends BaseExcelCache<CPromotion018SevenDayTarget> implements ILoopingPromotionCache {

    private Map<Integer, List<CPromotion018SevenDayTarget>> map;
    private int maxTurns;

    @Override
    public String getFileName() {
        return "promotion7daytarget";
    }

    @Override
    protected void loadAfterReady() {
        this.map = this.fillListMap(CPromotion018SevenDayTarget::getTurns);
        for (Integer turns : map.keySet()) {
            if (turns > maxTurns) {
                maxTurns = turns;
            }
        }
    }

    /**
     * 根据轮次获取配置信息
     *
     * @param turns
     * @return
     */
    public List<CPromotion018SevenDayTarget> getList(int turns) {
        List<CPromotion018SevenDayTarget> list = map.get(turns);
        ConfigAsserts.notNull(list, () -> String.format("CPromotion018SevenDayTarget配置数据不存在配置轮次:{%s}", turns));
        return list;
    }

    @Override
    public int getMaxTurns() {
        return maxTurns;
    }

}