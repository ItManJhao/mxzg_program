package com.ayjs.mxzg.gameserver.module.weekendGift.struct;

/**
 * @Author: CWJ
 * @Date: 2020/3/21
 **/
public enum WeekendGiftRewardStatus {

    NOT(0),
    CAN(1),
    HAD(2),
    ;
    private int value;

    WeekendGiftRewardStatus(int value) {
        this.value = value;
    }

    public int getValue() {
        return value;
    }
}
