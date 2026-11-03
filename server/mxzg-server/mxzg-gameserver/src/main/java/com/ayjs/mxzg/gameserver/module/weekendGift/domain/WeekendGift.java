package com.ayjs.mxzg.gameserver.module.weekendGift.domain;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import lombok.Data;

import java.util.HashMap;
import java.util.Map;

/**
 * @Author: CWJ
 * @Date: 2020/3/21
 **/
@Table(name = "weekend_gift", comment = "周末礼包")
@Data
public class WeekendGift extends AbstractEntity {

    @Id
    @Column(name = "rid", comment = "角色id")
    private long rid;

    @Column(name = "reward_status", comment = "可领取状态,0不可领取；1可领取；2以领取")
    private Map<Integer, Integer> rewardStatus = new HashMap<>();
    @Column(name = "start_time", comment = "开始时间")
    private int startTime;
    @Column(name = "end_time", comment = "结束时间")
    private int endTime;
}
