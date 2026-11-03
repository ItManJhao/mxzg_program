package com.ayjs.mxzg.battle.model;

import com.ayjs.mxzg.common.convert.annotation.EnumMode;
import com.ayjs.mxzg.common.convert.annotation.ValueMode;

/**
 * 战斗事件类型
 */
@EnumMode(ValueMode.VALUE)
public enum FightEventType {

    /** 格挡*/
    BLOCK(1),

    /** 闪避*/
    MISS(2),
    ;


    private int code;

    private FightEventType(int code){
        this.code = code;
    }
}
