package com.ayjs.mxzg.config.excel.cache.promotion;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.common.excel.ConfigAsserts;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion061ThreeDayTask;
import org.springframework.stereotype.Component;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 三日任务
 *
 * @author hyx
 */
@Component
public class Promotion061ThreeDayTaskSysCache extends BaseExcelCache<CPromotion061ThreeDayTask> implements ILoopingPromotionCache {

    /**
     * <轮次，<天数,任务>>
     */
    private Map<Integer, Map<Integer, List<CPromotion061ThreeDayTask>>> map;

    private int maxTurns;

    @Override
    protected void loadAfterReady() {
        Map<Integer, Map<Integer, List<CPromotion061ThreeDayTask>>> tempTurnDayMap = new HashMap<>();
        for (CPromotion061ThreeDayTask task : this.getAll()) {
            Map<Integer, List<CPromotion061ThreeDayTask>> turnsMap = tempTurnDayMap.get(task.getTurns());
            if (turnsMap == null) {
                turnsMap = new HashMap<>();
                tempTurnDayMap.put(task.getTurns(), turnsMap);
            }
            List<CPromotion061ThreeDayTask> dayList = turnsMap.get(task.getDay());
            if (dayList == null) {
                dayList = new ArrayList<>();
                turnsMap.put(task.getDay(), dayList);
            }
            dayList.add(task);
        }
        this.map = tempTurnDayMap;

        for (Integer turns : map.keySet()) {
            if (turns > maxTurns) {
                maxTurns = turns;
            }
        }

    }

    /**
     * 获取轮次及天数任务
     *
     * @param turns
     * @return
     */
    public List<CPromotion061ThreeDayTask> getTurnsTask(int turns) {
        Map<Integer, List<CPromotion061ThreeDayTask>> turnsMap = map.get(turns);
        ConfigAsserts.notNull(turnsMap, () -> String.format("三日任务promotion3daytask数据不存在轮次{%s}", turns));

        List<CPromotion061ThreeDayTask> taskList = new ArrayList<>();
        turnsMap.forEach((k, v) -> {
            taskList.addAll(v);
        });

        return taskList;
    }


    /**
     * 获取轮次及天数任务
     *
     * @param turns
     * @param day
     * @return
     */
    public List<CPromotion061ThreeDayTask> getTurnsDayTask(int turns, int day) {
        Map<Integer, List<CPromotion061ThreeDayTask>> turnsMap = map.get(turns);
        ConfigAsserts.notNull(turnsMap, () -> String.format("三日任务promotion3daytask数据不存在轮次{%s}", turns));
        List<CPromotion061ThreeDayTask> dayTasks = turnsMap.get(day);
        ConfigAsserts.notNull(turnsMap, () -> String.format("三日任务promotion3daytask数据不存在轮次{%s},天数{%s}", turns, day));
        return dayTasks;
    }


    @Override
    public String getFileName() {
        return "promotion3daytask";
    }


    @Override
    public int getMaxTurns() {
        return maxTurns;
    }
}
