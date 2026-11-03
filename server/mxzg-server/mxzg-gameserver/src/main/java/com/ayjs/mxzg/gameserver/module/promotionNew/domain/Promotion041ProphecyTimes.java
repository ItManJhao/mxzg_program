package com.ayjs.mxzg.gameserver.module.promotionNew.domain;


import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import lombok.Data;

import java.util.HashSet;
import java.util.Set;

@Data
@Entity
@Table(name = "promotion041_prophecy_time", comment = "先知召唤活动表")
public class Promotion041ProphecyTimes extends BaseLoopingPromotion {

    @Column(name = "times", comment = "先知召唤次数")
    private int times;

    @Column(name = "reward_idx", comment = "领取记录")
    private Set<Integer> rewardIdx = new HashSet<>();

    @Column(name = "round", comment = "奖励领取轮次", defaultValue = "0")
    private int round;

}
