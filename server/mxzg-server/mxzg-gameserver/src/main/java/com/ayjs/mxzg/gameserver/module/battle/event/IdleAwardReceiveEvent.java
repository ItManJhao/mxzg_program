package com.ayjs.mxzg.gameserver.module.battle.event;

import lombok.Value;

/**
 * 挂机奖励领取事件
 */
@Value(staticConstructor = "of")
public class IdleAwardReceiveEvent {

    private long rid;
    /**
     * 挂机时长
     */
    private int awardTime;


}
