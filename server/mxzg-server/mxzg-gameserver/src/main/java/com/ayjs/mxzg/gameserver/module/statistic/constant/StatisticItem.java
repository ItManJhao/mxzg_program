package com.ayjs.mxzg.gameserver.module.statistic.constant;

import lombok.extern.slf4j.Slf4j;

import java.util.HashMap;
import java.util.Map;

/**
 * 需要统计的道具
 */
@Slf4j
public enum StatisticItem {
    // 金币
    IT_GOLD(900001, 200000000L, true),
    // 金币
    IT_GEM(900002, 2000L, true),
    // 英雄经验
    IT_HERO_EXP(900101, 2000L, true),

    ;

    /**
     * 道具id
     */
    private int itemId;
    /**
     * 监控的上限值
     */
    private long value;
    /**
     * .
     * <p>
     * 是否按照充值金额成长
     */
    private boolean grow;

    StatisticItem(int itemId, long value, boolean grow) {
        this.itemId = itemId;
        this.value = value;
        this.grow = grow;
    }

    private static Map<Integer, StatisticItem> ENUMS = new HashMap<>();

    static {
        for (StatisticItem statisticItem : StatisticItem.values()) {
            if (ENUMS.containsKey(statisticItem.getValue())) {
                log.warn("statisticItem duplicate:{},{}", ENUMS.get(statisticItem.getValue()), statisticItem);
                continue;
            }
            ENUMS.put(statisticItem.getItemId(), statisticItem);
        }
    }

    public static boolean contain(int itemId) {
        return ENUMS.containsKey(itemId);
    }

    public int getItemId() {
        return itemId;
    }

    public long getValue() {
        return value;
    }

    public boolean isGrow() {
        return grow;
    }
}
