package com.ayjs.mxzg.gameserver.module.limitBuy.constant;

/**
 * @description: 限购类型
 * @author: CWJ
 * @date: 2019/10/15 21:31
 */
public enum LimitType {
    NO(0),
    DAY(1),
    WEEK(2),
    MONTH(3),
    GAME_ONCE(4),;

    private int type;

    LimitType(int type) {
        this.type = type;
    }

}
