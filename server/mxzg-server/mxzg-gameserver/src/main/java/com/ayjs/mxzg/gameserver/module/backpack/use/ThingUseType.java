package com.ayjs.mxzg.gameserver.module.backpack.use;

/**
 * 使用效果类型
 */
public enum ThingUseType {
    /**
     * 无
     */
    NONE(0),

    /**
     * 礼包
     */
    BOX_REWARD(1),

    /**
     * 合成英雄(逻辑写在功能模块中，没有这个通用的方案)
     */
    COMBINE_HERO(2),
    /**
     * 合成精英英雄(逻辑写在功能模块中，没有这个通用的方案)
     */
    COMBINE_ELITE_HERO(4),
    /**
     * 挂机礼包
     */
    IDLE_GIFT_PACKAGE(5),
    /**
     * 充值卡
     */
    RECHARGE_CARD(7),

    /**
     * 头像框(逻辑写在功能模块中，没有这个通用的方案)
     */
    ROLE_BORDER(99),

    ;

    private int value;

    ThingUseType(int value) {
        this.value = value;
    }

    public static ThingUseType of(int value) {
        for (ThingUseType type : ThingUseType.values()) {
            if (type.value == value) {
                return type;
            }
        }
        return NONE;
    }

    public int getValue() {
        return this.value;
    }
}
