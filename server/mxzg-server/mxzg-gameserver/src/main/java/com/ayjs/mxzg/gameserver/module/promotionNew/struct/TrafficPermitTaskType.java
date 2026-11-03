package com.ayjs.mxzg.gameserver.module.promotionNew.struct;

/**
 * 通行证活动任务类型
 * @author hyx
 */
public enum TrafficPermitTaskType {

    DAY_TASK(1),
    WEEK_TASK(2),
    Month_TASK(3)
    ;


    TrafficPermitTaskType(int value){
        this.value = value;
    };

    private int value;

    public int getValue() {
        return value;
    }

}
