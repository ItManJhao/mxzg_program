package com.ayjs.mxzg.gameserver.module.firstRecharge.domain;

import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Table;

import lombok.Getter;
import lombok.Setter;

/**
 * 首充礼包
 *
 * @Author: CWJ
 * @Date: 2019/10/30
 **/
@Table(name = "first_recharge", comment = "首充")
@Entity
@Getter
@Setter
public class FirstRecharge extends AbstractEntity {
    @Id
    @Column(name = "rid")
    private long rid;
    @Column(name = "active_time_map", comment = "首充激活时间")
    private Map<Integer, Integer> activeTimeMap = new HashMap<>();
    @Column(name = "reward_time")
    private Map<Integer, Integer> rewardTime = new HashMap<>();
    @Column(name = "rewards")
    private Set<Integer> rewards = new HashSet<>();
}
