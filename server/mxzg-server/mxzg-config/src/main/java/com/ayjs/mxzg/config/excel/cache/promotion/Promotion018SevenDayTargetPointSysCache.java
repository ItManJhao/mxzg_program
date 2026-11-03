package com.ayjs.mxzg.config.excel.cache.promotion;


import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.common.excel.ConfigAsserts;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion018SevenDayTargetPoint;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Map;

@Component
public class Promotion018SevenDayTargetPointSysCache extends BaseExcelCache<CPromotion018SevenDayTargetPoint> {

    private Map<Integer, List<CPromotion018SevenDayTargetPoint>> map;
    private int maxTurns;

    @Override
    public String getFileName() {
        return "promotion7daytargetpoint";
    }

    @Override
    protected void loadAfterReady() {
        this.map = this.fillListMap(CPromotion018SevenDayTargetPoint::getTurns);
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
    public CPromotion018SevenDayTargetPoint getConfig(int turns, int idx) {
        List<CPromotion018SevenDayTargetPoint> list = map.get(turns);
        ConfigAsserts.notNull(list, () -> String.format("CPromotion018SevenDayTargetPoint配置数据不存在配置轮次:{%s}", turns));

        CPromotion018SevenDayTargetPoint cPromotion018SevenDayTargetPoint = null;
        for (CPromotion018SevenDayTargetPoint config : list) {
            if (config.getIdx() == idx) {
                cPromotion018SevenDayTargetPoint = config;
            }
        }
        ConfigAsserts.notNull(cPromotion018SevenDayTargetPoint, () -> String.format("CPromotion018SevenDayTargetPoint配置数据不存在配置轮次:{%s},宝箱idx:{%s}:", turns, idx));

        return cPromotion018SevenDayTargetPoint;
    }

}