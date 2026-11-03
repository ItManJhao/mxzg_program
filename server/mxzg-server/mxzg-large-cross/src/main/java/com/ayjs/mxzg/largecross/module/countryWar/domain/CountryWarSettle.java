package com.ayjs.mxzg.largecross.module.countryWar.domain;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.message.module.floatingIslands.struct.RankData;
import lombok.Getter;
import lombok.Setter;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @Author: CWJ
 * @Date: 2021/4/12
 **/
@Getter
@Setter
@Table(name = "country_war_settle", comment = "国战结算记录")
public class CountryWarSettle extends AbstractEntity {

    @Id
    @Column(name = "round", comment = "轮次")
    private int round;

    @Column(name = "server_2_group", comment = "服务器分组信息")
    private Map<Integer, Integer> server2Group = new HashMap<>();

    @Column(name = "score_rank", comment = "积分榜")
    private Map<Integer, List<RankData>> scoreRank = new HashMap<>();

    @Column(name = "hero_rank", comment = "英雄榜榜")
    private Map<Integer, List<RankData>> heroRank = new HashMap<>();

    @Column(name = "kill_rank", comment = "杀敌榜")
    private Map<Integer, List<RankData>> killRank = new HashMap<>();

    @Column(name = "damage_rank", comment = "伤害榜")
    private Map<Integer, List<RankData>> damageRank = new HashMap<>();
}
