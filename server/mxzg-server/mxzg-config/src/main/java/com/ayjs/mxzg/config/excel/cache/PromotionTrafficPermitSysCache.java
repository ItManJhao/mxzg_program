package com.ayjs.mxzg.config.excel.cache;


import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.common.excel.ConfigAsserts;
import com.ayjs.mxzg.config.excel.cache.promotion.ILoopingPromotionCache;
import com.ayjs.mxzg.config.excel.entity.CPromotionTrafficPermit;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@Component
public class PromotionTrafficPermitSysCache extends BaseExcelCache<CPromotionTrafficPermit> implements ILoopingPromotionCache {

    //Map<配置轮次，任务类型，任务轮次>
    private Map<Integer, Map<Integer, Map<Integer, List<CPromotionTrafficPermit>>>> taskMap;
    private int maxTurns;

    @Override
    public String getFileName() {
        return "promotiontrafficpermit";
    }

    @Override
    protected void loadAfterReady() {
        Map<Integer, Map<Integer, Map<Integer, List<CPromotionTrafficPermit>>>> poolNeedMapTemp = new HashMap<>();
        for (CPromotionTrafficPermit cPromotionTrafficPermit : getAll()) {

            //配置轮次为key
            Map<Integer, Map<Integer, List<CPromotionTrafficPermit>>> configMap = poolNeedMapTemp.computeIfAbsent(
                    cPromotionTrafficPermit.getConfig_turns(), k -> new HashMap<>());

            //任务类型为key
            Map<Integer, List<CPromotionTrafficPermit>> taskMap = configMap.computeIfAbsent(
                    cPromotionTrafficPermit.getTask_type(), k -> new HashMap<>());

            //任务轮次为key
            List<CPromotionTrafficPermit> turnsList = taskMap.computeIfAbsent(cPromotionTrafficPermit.getTurns(),
                    k -> new ArrayList<>());

            turnsList.add(cPromotionTrafficPermit);

        }

        taskMap = poolNeedMapTemp;

        for (Integer turns : taskMap.keySet()) {
            if (turns > maxTurns) {
                maxTurns = turns;
            }
        }
    }

    @Override
    public int getMaxTurns() {
        return maxTurns;
    }

    public List<CPromotionTrafficPermit> getTaskList(int configTurns, int taskType, int turns) {

        Map<Integer, List<CPromotionTrafficPermit>> taskTypeMap = this.taskTypeTurns(configTurns,taskType);

        List<CPromotionTrafficPermit> taskList = taskTypeMap.get(turns);
        ConfigAsserts.notNull(taskList,
                () -> String.format("CPromotionTrafficPermit配置数据不存在配置轮次:{%s}，taskType:{%s},turns:{%s}", configTurns, taskType, turns));
        return taskList;
    }

    /**
     * 获取任务类型总轮次
     *
     * @return
     */
    public int getTaskTypeTurns(int configTurns, int taskType) {

        Map<Integer, List<CPromotionTrafficPermit>> taskTypeMap = this.taskTypeTurns(configTurns,taskType);

        return taskTypeMap.size();
    }


    private Map<Integer, List<CPromotionTrafficPermit>> taskTypeTurns(int configTurns, int taskType) {

        Map<Integer, Map<Integer, List<CPromotionTrafficPermit>>> turnTaskMap = taskMap.get(configTurns);
        ConfigAsserts.notNull(turnTaskMap,
                () -> String.format("CPromotionTrafficPermit配置数据不存在配置轮次:{%s}", configTurns));

        Map<Integer, List<CPromotionTrafficPermit>> taskTypeMap = turnTaskMap.get(taskType);
        ConfigAsserts.notNull(taskTypeMap,
                () -> String.format("CPromotionTrafficPermit配置数据不存在配置轮次:{%s}，taskType:{%s}", configTurns, taskType));
        return taskTypeMap;
    }

}
