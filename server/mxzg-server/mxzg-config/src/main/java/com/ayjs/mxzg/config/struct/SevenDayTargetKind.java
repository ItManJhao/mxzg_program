package com.ayjs.mxzg.config.struct;

/**
 * @Author: CWJ
 * @Date: 2019/11/18
 **/
public enum SevenDayTargetKind {

    /**
     * 任务
     */
    TASK(1),
    /**
     * 购买
     */
    BUY(2),
    ;
    private int value;

    SevenDayTargetKind(int value) {
        this.value = value;
    }

    public int getValue() {
        return value;
    }
}
