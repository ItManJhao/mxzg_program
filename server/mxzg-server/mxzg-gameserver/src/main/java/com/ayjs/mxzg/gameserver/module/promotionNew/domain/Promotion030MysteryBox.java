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
 * 神秘魔盒
 *
 * @Author: CWJ
 * @Date: 2019/10/26
 **/
@Entity
@Table(name = "promotion030_mystery_box", comment = "神秘魔盒")
@Data
public class Promotion030MysteryBox extends BaseLoopingPromotion {
    @Column(name = "recharge")
    private int recharge;
    @Column(name = "recharge_reward_record")
    private Set<Integer> rechargeRewardRecord = new HashSet<>();
    @Column(name = "exp")
    private int exp;
    //    @Column(name = "level")
//    private int level;
    @Column(name = "count_map", length = 1024)
    private Map<Integer, Integer> countMap = new HashMap<>();
    @Column(name = "reward_record")
    private Set<Integer> rewardRecord = new HashSet<>();
    @Column(name = "level_reward")
    private Set<Integer> levelRewardRecord = new HashSet<>();
    @Column(name = "curr_day")
    private int currDay;
    @Column(name = "last_login_time")
    private int lastLoginTime;

}
