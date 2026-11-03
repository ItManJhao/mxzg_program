package com.ayjs.mxzg.config.excel.cache.promotion;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.common.excel.ConfigAsserts;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion061ThreeDayTask;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion061ThreeDayTaskReward;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Map;

/**
 * 三日任务终极奖励
 * @author hyx
 */
@Component
public class Promotion061ThreeDayTaskRewardSysCache extends BaseExcelCache<CPromotion061ThreeDayTaskReward> {

    /**
     * <轮次，<天数,奖励>>
     */
    private Map<Integer, Map<Integer, CPromotion061ThreeDayTaskReward>> map;

    @Override
    protected void loadAfterReady() {
        map = this.fillTwoLayerMap(CPromotion061ThreeDayTaskReward::getTurns,CPromotion061ThreeDayTaskReward::getDay);
    }

    public CPromotion061ThreeDayTaskReward getTurnsDay(int turns,int day){
        Map<Integer, CPromotion061ThreeDayTaskReward> turnsMap = map.get(turns);
        ConfigAsserts.notNull(turnsMap, () -> String.format("三日任务promotion3daytaskreward数据不存在轮次{%s}", turns));
        CPromotion061ThreeDayTaskReward config = turnsMap.get(day);
        ConfigAsserts.notNull(turnsMap, () -> String.format("三日任务promotion3daytaskreward数据不存在轮次{%s},天数{%s}", turns, day));
        return config;
    }

    @Override
    public String getFileName() {
        return "promotion3daytaskreward";
    }
}
