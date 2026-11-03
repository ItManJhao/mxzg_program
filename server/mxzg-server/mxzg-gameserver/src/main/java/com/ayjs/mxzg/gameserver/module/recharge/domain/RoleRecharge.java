package com.ayjs.mxzg.gameserver.module.recharge.domain;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Table;

import lombok.Data;

/**
 * @description: 玩家充值表
 * @author: CWJ
 * @date: 2019/10/15 11:05
 */
@Entity
@Table(name = "role_charge", comment = "玩家充值表")
@Data
public class RoleRecharge extends AbstractEntity {

    @Id
    @Column(name = "rid", readOnly = true)
    private long rid;
    @Column(name = "total_recharge", comment = "历史累计充值金额")
    private long totalRecharge;
    @Column(name = "daily_recharge")
    private long dailyRecharge;
    @Column(name = "weekly_recharge")
    private long weeklyRecharge;
    @Column(name = "recharge_time")
    private long rechargeTime;
    @Column(name = "recharge_days", comment = "累计充值天数")
    private int rechargeDays;
    @Column(name = "had_buy_found", comment = "是否已购买基金")
    private boolean hadBuyFound;
    @Column(name = "daily_recharge_gift_time", comment = "每日充值领取时间")
    private long dailyRechargeGiftTime;
    @Column(name = "daily_recharge_reward", comment = "每日充值领奖记录", length = 500)
    private Set<Integer> dailyRechargeReward;
    @Column(name = "today_first_reward")
    private int todayFirstReward;
    @Column(name = "charged_info", comment = "购买过的充值商品", length = 500)
    private Set<Integer> chargedInfo;
    @Column(name = "untell_recharge", comment = "购买过但没有推送到前端的充值商品ID", length = 500)
    private List<Integer> untellRecharge;
    @Column(name = "register_gift", comment = "注册礼品", length = 500)
    private Set<Integer> registerGift = new HashSet<>();
    @Column(name = "first_recharge_id", comment = "首充的商品id")
    private int firstRechargeId;
    @Column(name = "first_recharge_time", comment = "首充的时间戳")
    private long firstRechargeTime;
}
