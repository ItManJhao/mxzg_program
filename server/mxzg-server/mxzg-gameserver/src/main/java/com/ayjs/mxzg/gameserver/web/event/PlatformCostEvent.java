package com.ayjs.mxzg.gameserver.web.event;


import lombok.Value;

import java.util.Map;

/***
 * 平台扣除道具充值事件
 */
@Value(staticConstructor = "of")
public class PlatformCostEvent {

    private long rid;

    private Map<Integer, Long> costItem;

    /***
     * 扣除充值
     * 1，总值，2周值，3日值
     */
    private Map<Integer, Long> costRecharge;

    public enum RechargeType {
        TOTAL(1),
        WEEK(2),
        DAILY(3),
        ;
        private int value;

        RechargeType(int value) {
            this.value = value;
        }

        public int getValue() {
            return value;
        }
    }
}
