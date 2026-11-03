package com.ayjs.mxzg.gameserver.module.promotionNew.promotion074.domain;

import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.BaseLoopingPromotion;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.google.common.collect.Sets;
import lombok.Getter;
import lombok.Setter;

import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 * @Author: CWJ
 * @Date: 2020/9/22
 **/
@Entity
@Table(name = "promotion074", comment = "中秋活动")
@Getter
@Setter
public class Promotion074 extends BaseLoopingPromotion {

    @Column(name = "select_info", comment = "选择奖励信息")
    private Map<Integer, Integer> selectInfo = Maps.newHashMap();
    @Column(name = "lottery_count", comment = "抽奖次数")
    private int lotteryCount;
    @Column(name = "lottery_turn_count", comment = "本轮抽奖次数")
    private int lotteryTurnCount;
    @Column(name = "lottery_turn_record", comment = "本轮抽奖记录")
    private Set<Integer> lotteryTurnRecord = Sets.newHashSet();
    @Column(name = "lottery_count_record", comment = "抽奖次数领取记录")
    private List<Integer> lotteryCountRecord = Lists.newArrayList();

}
