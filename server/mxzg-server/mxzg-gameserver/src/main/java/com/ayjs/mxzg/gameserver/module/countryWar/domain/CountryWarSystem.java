package com.ayjs.mxzg.gameserver.module.countryWar.domain;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import lombok.Getter;
import lombok.Setter;

import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentMap;

/**
 * @Author: CWJ
 * @Date: 2021/4/21
 **/
@Entity
@Table(name = "country_war_system", comment = "国战系统")
@Getter
@Setter
public class CountryWarSystem extends AbstractEntity {

    @Id
    @Column(name = "rid", comment = "角色id")
    private long id;
    @Column(name = "round", comment = "轮次")
    private int round;
    @Column(name = "reward_round", comment = "已经发奖轮次")
    private int rewardRound;
    @Column(name = "city_reward_count", comment = "城池发奖次数")
    private ConcurrentMap<Integer, Integer> cityRewardCount = new ConcurrentHashMap<>();
    @Column(name = "event_reward_count", comment = "事件发奖次数")
    private ConcurrentMap<Integer, Integer> eventRewardCount = new ConcurrentHashMap<>();

//    @Column
//    private int round;

}
