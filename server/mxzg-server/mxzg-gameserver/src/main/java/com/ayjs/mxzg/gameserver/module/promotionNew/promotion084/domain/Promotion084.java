package com.ayjs.mxzg.gameserver.module.promotionNew.promotion084.domain;

import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.BaseLoopingPromotion;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDate;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

/**
 * @Author: CWJ
 * @Date: 2020/9/22
 **/
@Entity
@Table(name = "promotion084", comment = "三日累充")
@Getter
@Setter
public class Promotion084 extends BaseLoopingPromotion {

    @Column(name = "recharge_refresh", comment = "充值时间")
    private LocalDate rechargeRefresh = LocalDate.of(2000, 11, 30);
    @Column(name = "reward_record", comment = "领奖记录")
    private Set<Integer> rewardRecord = new HashSet<>();
    @Column(name = "recharge_info", comment = "充值信息")
    private Map<Integer, Long> rechargeInfo = new HashMap<>();
    @Column(name = "curr_day", comment = "当前天数")
    private int currDay;

}
