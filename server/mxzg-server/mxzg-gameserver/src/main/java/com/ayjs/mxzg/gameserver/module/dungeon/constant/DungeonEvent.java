package com.ayjs.mxzg.gameserver.module.dungeon.constant;

import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 地牢事件类型枚举
 */
public enum DungeonEvent {

	NO_EVENT(100),  //空事件
    GOLD_EVENT(101),    //金币事件
    STONE_EVENT(102),  //石堆事件
    FREE_BOX_EVENT(103),   //免费宝箱事件
    KEY_EVENT(104),     //钥匙事件
    KEY_BOX_EVENT(105),     //钥匙宝箱事件
    BUFF_EVENT(106),    //BUFF事件
    HP_EVENT(107),    //生命药水事件
    SHOP_EVENT(108),    //商店事件
    SUMMON_SHOP_EVENT(109), //召唤商人事件
    MELEE_EVENT(110),   //乱斗事件
    DIALOGUE_EVENT(111),  //对话事件
    MORRA_EVENT(112),   //猜拳事件
    ASSASSIN_EVENT(113),    //刺客事件
    SKULL_EVENT(114),   //骷髅事件
    DISPEL_EVENT(115),//驱散药水事件
    BOSS_EVENT(-1),    //地牢怪物事件
    ;

    private int eventType;

    public int getEventType() {
        return eventType;
    }

    DungeonEvent(int eventType) {
        this.eventType = eventType;
    }

    private static List<Integer> notResourceEvent = new ArrayList<>();

    private static Map<Integer,DungeonEvent> eventMap = new HashMap<>();

    static {
        notResourceEvent.add(NO_EVENT.getEventType());
        notResourceEvent.add(FREE_BOX_EVENT.getEventType());
        notResourceEvent.add(KEY_BOX_EVENT.getEventType());
        notResourceEvent.add(SHOP_EVENT.getEventType());
        notResourceEvent.add(BOSS_EVENT.getEventType());
        notResourceEvent.add(MELEE_EVENT.getEventType());
        notResourceEvent.add(DIALOGUE_EVENT.getEventType());
        notResourceEvent.add(MORRA_EVENT.getEventType());
        notResourceEvent.add(ASSASSIN_EVENT.getEventType());
        notResourceEvent.add(SKULL_EVENT.getEventType());

        for (DungeonEvent type : DungeonEvent.values()) {
            eventMap.put(type.getEventType(), type);
        }

    }

    public static DungeonEvent valueOf(Integer type){
        return eventMap.get(type);
    }

    public static List<Integer> getNotResourceEvent() {
        return notResourceEvent;
    }
}
