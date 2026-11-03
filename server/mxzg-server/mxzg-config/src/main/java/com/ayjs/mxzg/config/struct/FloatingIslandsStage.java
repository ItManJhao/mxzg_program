package com.ayjs.mxzg.config.struct;

/**
 * @Author: CWJ
 * @Date: 2020/7/1
 **/
public enum FloatingIslandsStage {

    OVER(1),

    CHALLENGE_BOSS(2),

    CHALLENGE_SETTLE(3);

    private int code;

    FloatingIslandsStage(int code) {
        this.code = code;
    }

    public int getCode() {
        return code;
    }

    private static FloatingIslandsStage[] stages = null;

    static {
        stages = new FloatingIslandsStage[FloatingIslandsStage.values().length];
        for (FloatingIslandsStage state : FloatingIslandsStage.values()) {
            stages[state.getCode() - 1] = state;
        }
    }

    public static FloatingIslandsStage getStage(int code) {
        if (code <= 0 || code > stages.length) {
            return null;
        }
        return stages[code - 1];
    }

    public FloatingIslandsStage nextStage() {
        return stages[code % stages.length];
    }

}
