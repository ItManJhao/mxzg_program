package com.ayjs.mxzg.config.excel.cache.promotion;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.common.excel.ConfigAsserts;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion064DragonBoatTask;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Map;

/**
 * 龙舟活动
 *
 * @author hyx
 */
@Component
public class Promotion064DragonBoatTaskSysCache extends BaseExcelCache<CPromotion064DragonBoatTask> {

    private Map<Integer, List<CPromotion064DragonBoatTask>> taskMap;

    private int maxTurns;

    @Override
    protected void loadAfterReady() {
        taskMap = this.fillListMap(CPromotion064DragonBoatTask::getDay_turns);

        for (int turns : taskMap.keySet()) {
            if (turns > maxTurns) {
                maxTurns = turns;
            }
        }
    }

    public int getMaxTurns() {
        return maxTurns;
    }

    @Override
    public String getFileName() {
        return "promotiondragonboattask";
    }

    public List<CPromotion064DragonBoatTask> getDayTask(int dayTurns) {
        List<CPromotion064DragonBoatTask> tasks = taskMap.get(dayTurns);
        ConfigAsserts.notNull(tasks, () -> String.format("龙舟活动任务promotiondragonboattask数据不存在天数{%s}的任务", dayTurns));
        return tasks;
    }

}
