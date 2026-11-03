package com.ayjs.mxzg.battle.model;

import lombok.Data;

import java.util.HashMap;
import java.util.Map;

/**
 * 战斗事件领域
 */
@Data(staticConstructor="instance")
public class FightEventDo {

    /**事件类型对应的次数*/
    private Map<FightEventType, Integer> eventTypeCountMap = new HashMap<>();


    /**
     * 增加事件次数
     * @param eventType
     */
    public void increase(FightEventType eventType){
        int times = getEventTimes(eventType);
        this.eventTypeCountMap.put(eventType, ++times);
    }

    /**
     * 移除事件计数
     * @param eventType
     */
    public void clean(FightEventType eventType){
        this.eventTypeCountMap.remove(eventType);
    }

    /**
     * 获取事件次数
     * @param eventType
     * @return
     */
    public int getEventTimes(FightEventType eventType){
        return this.eventTypeCountMap.getOrDefault(eventType, 0);
    }
}
