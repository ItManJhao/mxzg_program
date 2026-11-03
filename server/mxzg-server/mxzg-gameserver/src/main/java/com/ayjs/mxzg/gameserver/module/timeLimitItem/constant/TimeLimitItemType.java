package com.ayjs.mxzg.gameserver.module.timeLimitItem.constant;

import java.util.HashMap;
import java.util.Map;

/**
 * @author hyx
 */
public enum TimeLimitItemType {

    /**
     * 周卡道具
     */
    WEEKS_CARD(1),
    ;

    TimeLimitItemType(int type) {
        this.type = type;
    }

    private int type;

    public int getType() {
        return type;
    }

    private static Map<Integer, TimeLimitItemType> typeMap = new HashMap<>();

    static {
        for (TimeLimitItemType type : TimeLimitItemType.values()) {
            typeMap.put(type.getType(), type);
        }
    }

    public static TimeLimitItemType valueOf(int type) {
        return typeMap.get(type);
    }


}

