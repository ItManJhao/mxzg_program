package com.ayjs.mxzg.gameserver.module.promotionNew.event;

import lombok.Value;

/**
 * 七天登录领奖事件
 *
 * @Author: CWJ
 * @Date: 2019/11/12
 **/
@Value(staticConstructor = "of")
public class SevenDayLoginRewardEvent {

    private long rid;
    /**
     * 领取天数
     */
    private int day;
}
