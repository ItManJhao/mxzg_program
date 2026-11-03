package com.ayjs.mxzg.gameserver.module.promotionNew.domain;

import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import lombok.Data;

import java.util.HashSet;
import java.util.Set;

/**
 * 累计充值活动
 *
 * @Author: CWJ
 * @Date: 2019/10/22
 **/
@Table(name = "promotion048_weekly_recharge", comment = "累计充值活动")
@Data
public class Promotion048WeeklyRecharge extends BaseLoopingPromotion {

    @Column(name = "recharge", comment = "充值金额，分")
    private int recharge;
    @Column(name = "reward_idx", comment = "领取记录")
    private Set<Integer> rewardIdx = new HashSet<>();

}
