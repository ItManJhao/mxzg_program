package com.ayjs.mxzg.gameserver.module.promotionNew.domain;

import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import lombok.Data;

import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

/**
 * 玩家狂欢时刻表
 *
 * @Author: CWJ
 * @Date: 2019/10/21
 **/
@Entity
@Table(name = "promotion035_happy_time", comment = "狂欢时刻")
@Data
public class Promotion035HappyTime extends BaseLoopingPromotion {
    @Column(name = "buy_privilege", comment = "是否购买特权")
    private boolean buyPrivilege;
    @Column(name = "process_map",length = 1024)
    private Map<Integer, Integer> processMap = new HashMap<>();
    @Column(name = "reward_record")
    private Set<Integer> rewardRecord = new HashSet<>();
    @Column(name = "privilege_reward_record")
    private Set<Integer> privilegeRewardRecord = new HashSet<>();

}
