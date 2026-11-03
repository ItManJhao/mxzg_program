package com.ayjs.mxzg.gameserver.module.fetter.constant;

/**
 * 羁绊女神重置验证
 */
public enum GoddessResetResult {

    ACHIEVE(0),//验证通过

    GEM(1),//钻石不足

    GODDESS(2),//idx错误

    GODDESS_LEVEL(3),//0级不能重置
            ;

    private int type;

    GoddessResetResult(int type){this.type = type;};

    public int getType() {
        return type;
    }
}
