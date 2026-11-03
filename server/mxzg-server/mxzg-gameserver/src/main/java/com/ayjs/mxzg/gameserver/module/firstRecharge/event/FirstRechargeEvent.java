package com.ayjs.mxzg.gameserver.module.firstRecharge.event;

import lombok.Value;

/**
 * 领取首充奖励
 *
 * @author hyx
 */
@Value(staticConstructor = "of")
public class FirstRechargeEvent {

    private long rid;

}
