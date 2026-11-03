package com.ayjs.mxzg.gameserver.module.hero.struct;

import com.ayjs.mxzg.config.excel.constant.HeroConst;

import java.util.HashMap;
import java.util.Map;

/**
 * 英雄祈愿
 * @author hyx
 */
public enum PrayerType {

    /**
     * 火系
     */
    FIRE(1, HeroConst.ADV_WISH_FIRE_REWARD_TYPE),
    /**
     * 水系
     */
    WATER(2, HeroConst.ADV_WISH_WATER_REWARD_TYPE),
    /**
     * 草系
     */
    WOOD(3, HeroConst.ADV_WISH_WOOD_REWARD_TYPE),
    ;

    private int type;

    private int value;

    PrayerType(int type,int value){
        this.type = type;
        this.value = value;
    }

    public int getType() {
        return type;
    }

    public int getValue() {
        return value;
    }

    private static Map<Integer, PrayerType> typeMap = new HashMap<>();

    static {
        for (PrayerType prayerType : PrayerType.values()) {
            typeMap.put(prayerType.type, prayerType);
        }
    }

    public static PrayerType valueOf(int id) {
        return typeMap.get(id);
    }

}
