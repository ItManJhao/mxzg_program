package com.ayjs.mxzg.gameserver.module.promotionNew.promotion091.domain;

import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.BaseLoopingPromotion;
import lombok.Getter;
import lombok.Setter;

import java.util.HashMap;
import java.util.Map;

@Getter
@Setter
@Entity
@Table(name = "promotion091", comment = "春节抽奖")
public class Promotion091 extends BaseLoopingPromotion {
    @Column(name = "lottery_record", comment = "抽奖记录")
    private Map<Integer, Map<Integer, Integer>> lotteryRecord = new HashMap<>();

    @Column(name = "lottery_turns", comment = "轮次")
    private int lotteryTurns;

    @Column(name = "lottery_count", comment = "抽奖次数")
    private int lotteryCount;

}
