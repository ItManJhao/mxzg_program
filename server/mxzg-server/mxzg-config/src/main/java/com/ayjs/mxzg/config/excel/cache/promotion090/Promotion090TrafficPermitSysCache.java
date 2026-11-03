package com.ayjs.mxzg.config.excel.cache.promotion090;


import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.common.excel.ConfigAsserts;
import com.ayjs.mxzg.config.excel.cache.promotion.ILoopingPromotionCache;
import com.ayjs.mxzg.config.excel.entity.promotion090.CPromotion090TrafficPermit;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@Component
public class Promotion090TrafficPermitSysCache extends BaseExcelCache<CPromotion090TrafficPermit> implements ILoopingPromotionCache {

    //Map<配置轮次，任务类型，任务轮次>
    private Map<Integer, Map<Integer, Map<Integer, List<CPromotion090TrafficPermit>>>> taskMap;
    private int maxTurns;

    @Override
    public String getFileName() {
        return "promotion090trafficpermit";
    }

    @Override
    protected void loadAfterReady() {
        Map<Integer, Map<Integer, Map<Integer, List<CPromotion090TrafficPermit>>>> poolNeedMapTemp = new HashMap<>();
        for (CPromotion090TrafficPermit cPromotionTrafficPermit : getAll()) {

            //配置轮次为key
            Map<Integer, Map<Integer, List<CPromotion090TrafficPermit>>> configMap = poolNeedMapTemp.computeIfAbsent(
                    cPromotionTrafficPermit.getConfig_turns(), k -> new HashMap<>());

            //任务类型为key
            Map<Integer, List<CPromotion090TrafficPermit>> taskMap = configMap.computeIfAbsent(
                    cPromotionTrafficPermit.getTask_type(), k -> new HashMap<>());

            //任务轮次为key
            List<CPromotion090TrafficPermit> turnsList = taskMap.computeIfAbsent(cPromotionTrafficPermit.getTurns(),
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

    public List<CPromotion090TrafficPermit> getTaskList(int configTurns, int taskType, int turns) {

        Map<Integer, List<CPromotion090TrafficPermit>> taskTypeMap = this.taskTypeTurns(configTurns,taskType);

        List<CPromotion090TrafficPermit> taskList = taskTypeMap.get(turns);
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
        Map<Integer, List<CPromotion090TrafficPermit>> taskTypeMap = this.taskTypeTurns(configTurns,taskType);
        return taskTypeMap.size();
    }


    private Map<Integer, List<CPromotion090TrafficPermit>> taskTypeTurns(int configTurns, int taskType) {

        Map<Integer, Map<Integer, List<CPromotion090TrafficPermit>>> turnTaskMap = taskMap.get(configTurns);
        ConfigAsserts.notNull(turnTaskMap,
                () -> String.format("CPromotion090TrafficPermit配置数据不存在配置轮次:{%s}", configTurns));

        Map<Integer, List<CPromotion090TrafficPermit>> taskTypeMap = turnTaskMap.get(taskType);
        ConfigAsserts.notNull(taskTypeMap,
                () -> String.format("CPromotion090TrafficPermit配置数据不存在配置轮次:{%s}，taskType:{%s}", configTurns, taskType));
        return taskTypeMap;
    }

}
