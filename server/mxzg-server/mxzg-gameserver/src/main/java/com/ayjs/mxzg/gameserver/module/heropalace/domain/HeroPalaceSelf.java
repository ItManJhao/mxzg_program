package com.ayjs.mxzg.gameserver.module.heropalace.domain;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDate;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

/**
 * @Author: CWJ
 * @Date: 2020/3/24
 **/
@Entity
@Table(name = "hero_palace_self", comment = "我的英雄殿堂")
@Getter
@Setter
public class HeroPalaceSelf extends AbstractEntity {
    @Id
    @Column(name = "rid", comment = "角色id")
    private long rid;
    @Column(name = "worship_type", comment = "已膜拜类型")
    private Set<Integer> worshipType = new HashSet<>();
    @Column(name = "worship_time", comment = "膜拜时间-废弃")
    private LocalDate worshipTime;
    @Column(name = "worship_time_data", comment = "膜拜时间-时间戳")
    private int worshipTimeData;

    @Column(name = "reward_type", comment = "排名奖励领取记录")
    private Set<Integer> rewardType = new HashSet<>();

    @Column(name = "hero_num", comment = "排名奖励领取记录")
    private Map<Integer, Integer> heroNum = new HashMap<>();

}
