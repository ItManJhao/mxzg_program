package com.ayjs.mxzg.gameserver.module.promotionNew.promotion089.domain;

import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.BaseLoopingPromotion;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Entity
@Table(name = "promotion089", comment = "圣诞感恩信")
public class Promotion089 extends BaseLoopingPromotion {
    @Column(name = "reward_time", comment = "奖励时间")
    private int rewardTime;
}
