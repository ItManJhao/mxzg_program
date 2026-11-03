package com.ayjs.mxzg.gameserver.module.promotionNew.event;

import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;

import lombok.Value;

/**
 * 活动领奖事件
 *
 * @Author: CWJ
 * @Date: 2019/10/25
 **/
@Value(staticConstructor = "of")
public class ActivityRewardEvent {
    private long rid;
    private PromotionType type;
    /**
     * 配置id
     */
    private int idx;
}
