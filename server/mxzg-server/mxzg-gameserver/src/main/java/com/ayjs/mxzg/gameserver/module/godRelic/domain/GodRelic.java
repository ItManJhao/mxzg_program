package com.ayjs.mxzg.gameserver.module.godRelic.domain;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import lombok.Data;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 * @Author: CWJ
 * @Date: 2020/3/23
 **/
@Table(name = "god_relic", comment = "诸神遗迹")
@Data
@Entity
public class GodRelic extends AbstractEntity {

    @Id
    @Column(name = "rid", comment = "角色id")
    private long rid;

//    @Column(name = "complete_target", comment = "通关条件集合", length = 1024)
//    private Map<Integer, Map<Integer, List<Integer>>> completeTarget = new HashMap<>();

    @Column(name = "star_reward_record", comment = "领取星际奖励")
    private Set<Integer> starRewardRecord = new HashSet<>();

    @Column(name = "rank_time", comment = "排名时间")
    private int rankTime;

    @Column(name = "can_challenge_count", comment = "可挑战次数")
    private int canChallengeCount;

    @Column(name = "buy_count", comment = "已购买次数")
    private int buyCount;

    @Column(name = "reset_time", comment = "重置时间")
    private LocalDate resetTime;

    @Column(name = "max_lv", comment = "最大关卡数")
    private int maxLevel;

    @Column(name = "max_chapter", comment = "最大篇章数")
    private int maxChapter;

    @Column(name = "sum_star", comment = "总星数")
    private int sumStar;


}
