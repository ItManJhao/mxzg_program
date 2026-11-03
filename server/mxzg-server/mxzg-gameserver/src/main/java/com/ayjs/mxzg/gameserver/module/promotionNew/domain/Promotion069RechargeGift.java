package com.ayjs.mxzg.gameserver.module.promotionNew.domain;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import lombok.Getter;
import lombok.Setter;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 超值赠礼
 *
 * @author hyx
 */
@Entity
@Table(name = "promotion069_recharge_gift", comment = "超值赠礼")
@Getter
@Setter
public class Promotion069RechargeGift extends AbstractEntity {

    @Id
    @Column(name = "rid", comment = "玩家id")
    private long rid;

    @Column(name = "open_time", comment = "开启时间")
    private int openTime = Integer.MAX_VALUE;

    @Column(name = "recharge", comment = "活动开启期间充值金额")
    private int recharge;

    @Column(name = "active_time_map", comment = "激活时间")
    private Map<Integer, Integer> activeTimeMap = new HashMap<>();

    @Column(name = "reward_list", comment = "一次性奖励已领取集")
    private List<Integer> rewardList = new ArrayList<>();

    @Column(name = "reward_time_map", comment = "可重复领取的奖励")
    private Map<Integer, Integer> rewardTimeMap = new HashMap<>();
}
