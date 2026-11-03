package com.ayjs.mxzg.cross.module.crossparam.constant;

public enum CrossParamType {
    /**
     * 天梯时间信息
     */
    LADDER_DATE_TIME(1),

    /**
     * 组队竞技场时间信息
     */
    TEAM_ARENA_TIME(2),

    ;

    private final int value;

    CrossParamType(int value) {
        this.value = value;
    }

    public int getValue() {
        return value;
    }
}
