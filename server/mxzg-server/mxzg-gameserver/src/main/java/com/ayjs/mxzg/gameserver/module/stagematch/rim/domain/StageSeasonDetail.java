package com.ayjs.mxzg.gameserver.module.stagematch.rim.domain;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Cache;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Index;
import com.ayjs.mxzg.common.persistence.annotation.LongIdGenerate;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import lombok.Getter;
import lombok.Setter;

import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

/**
 * @Author: CWJ
 * @Date: 2020/6/16
 **/
@Getter
@Setter
@Entity
@Table(name = "stage_season_detail", comment = "超凡段位赛赛季表", cache = {@Cache(columns = "rid")}
        , indexes = {@Index(columnList = "rid", name = "rid")})
public class StageSeasonDetail extends AbstractEntity {

    @Column(name = "id", comment = "唯一标识")
    @Id
    @LongIdGenerate
    private long id;

    @Column(name = "rid", comment = "角色id", readOnly = true)
    private long rid;

    @Column(name = "season_id", comment = "赛季id")
    private int seasonId;

    @Column(name = "stage_id", comment = "最大段位")
    private int stageId;

    @Column(name = "max_score", comment = "最大分数")
    private int maxScore;

    @Column(name = "normal_win_count", comment = "常规赛胜场数")
    private int normalWinCount;

    @Column(name = "normal_total_count", comment = "常规赛总场数")
    private int normalTotalCount;

    @Column(name = "elite_win_count", comment = "精英赛赛胜场数")
    private int eliteWinCount;

    @Column(name = "elite_total_count", comment = "精英赛赛总场数")
    private int eliteTotalCount;

    @Column(name = "max_winning_streak", comment = "最大连胜数")
    private int maxWinningStreak;

    @Column(name = "max_dmg", comment = "最大伤害")
    private long maxDmg;

    @Column(name = "strongest_opponent_fighting", comment = "最强对手队伍1战力")
    private long strongestOpponentFighting;

    @Column(name = "strongest_opponent_fighting2", comment = "最强对手队伍2战力")
    private long strongestOpponentFighting2;

    @Column(name = "strongest_opponent_rid", comment = "最强对手id")
    private long strongestOpponentRid;

    @Column(name = "curr_winning_streak", comment = "当前连胜数")
    private int currWinningStreak;

    @Column(name = "hero_mvp_count", comment = "英雄mvp次数")
    private Map<Integer, Integer> heroMvpCount = new HashMap<>();

    @Column(name = "mvp_hero_info", comment = "当前mvp英雄")
    private HeroMvpInfo mvpHero = new HeroMvpInfo();

    @Column(name = "stage_records", comment = "挑战奖励领取记录")
    private Set<Integer> stageRecords = new HashSet<>();
    @Column(name = "stage_token_records", comment = "战令领取记录")
    private Set<Integer> stageTokenRecords = new HashSet<>();

    @Column(name = "buy_stage_token", comment = "是否购买段位战令")
    private boolean buyStageToken;
}
