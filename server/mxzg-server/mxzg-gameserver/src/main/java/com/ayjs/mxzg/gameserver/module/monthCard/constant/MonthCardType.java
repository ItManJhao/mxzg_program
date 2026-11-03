package com.ayjs.mxzg.gameserver.module.monthCard.constant;

/**
 * @Author: CWJ
 * @Date: 2019/10/25
 **/
public enum MonthCardType {

    NORMAL(1),
    BEST(2),
    ;

    private int type;

    MonthCardType(int type) {
        this.type = type;
    }

    public int getType() {
        return type;
    }
}
