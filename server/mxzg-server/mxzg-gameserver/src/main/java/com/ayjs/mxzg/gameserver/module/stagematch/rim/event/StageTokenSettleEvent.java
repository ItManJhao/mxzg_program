package com.ayjs.mxzg.gameserver.module.stagematch.rim.event;

import lombok.Value;

/**
 * 战令结算事件
 *
 * @Author: CWJ
 * @Date: 2020/6/22
 **/
@Value(staticConstructor = "of")
public class StageTokenSettleEvent {
    /***
     * 结算的赛季id
     */
    private int season;
}
