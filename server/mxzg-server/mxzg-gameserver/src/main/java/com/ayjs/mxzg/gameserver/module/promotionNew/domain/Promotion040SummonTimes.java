package com.ayjs.mxzg.gameserver.module.promotionNew.domain;


import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import lombok.Data;
import java.util.HashSet;
import java.util.Set;

@Data
@Entity
@Table(name = "promotion040_summon_times",comment = "召唤达标活动表")
public class Promotion040SummonTimes extends BaseLoopingPromotion {

    @Column(name = "times",comment = "任务进度")
    private int times;

    @Column(name = "reward_idx",comment = "领取记录")
    private Set<Integer> rewardList = new HashSet<>();

    @Column(name = "round", comment = "奖励领取轮数")
    private int round;
}
