package com.ayjs.mxzg.gameserver.module.adven.constant;

/**
 * 勇者试炼防守方类型
 */
public enum AdvenDefendType {
    /**
     * 机器人
     */
    Robot(1),
    /**
     * 真实玩家
     */
    RealRole(2),
    ;

    private final int value;

    private AdvenDefendType(int value) {
        this.value = value;
    }

    public int getValue() {
        return value;
    }
}
