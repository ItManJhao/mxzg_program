package com.ayjs.mxzg.gameserver.module.monthCard.domain;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Cache;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Index;
import com.ayjs.mxzg.common.persistence.annotation.LongIdGenerate;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import lombok.Data;

/**
 * 月卡
 *
 * @Author: CWJ
 * @Date: 2019/10/16
 **/
@Table(name = "month_card", indexes = {@Index(name = "rid", columnList = {"rid"})}, cache = {@Cache(columns = {"rid"})})
@Entity
@Data
public class MonthCard extends AbstractEntity {

    @Id
    @LongIdGenerate
    @Column(name = "id")
    private long id;
    @Column(name = "rid", readOnly = true)
    private long rid;
    @Column(name = "idx")
    private int idx;
    @Column(name = "type", comment = "月卡类型")
    private int type;
    @Column(name = "start_time")
    private int startTime;
    @Column(name = "end_time")
    private int endTime;
    @Column(name = "recharge_count", comment = "充值金额")
    private int rechargeCount;
    @Column(name = "reward_count")
    private int rewardCount;
    @Column(name = "reward_time", comment = "领取时间")
    private int rewardTime;
    @Column(name = "base_card_reward_time",comment = "至尊月卡每日领奖时间")
    private int baseCardRewardTime;
}
