package com.ayjs.mxzg.gameserver.module.magicTower.domain;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDate;
import java.util.HashSet;
import java.util.Set;

/**
 * @Author: CWJ
 * @Date: 2021/6/18
 **/
@Table(name = "magic_tower", comment = "幻魔塔")
@Getter
@Setter
@Entity
public class MagicTower extends AbstractEntity {
    @Id
    @Column(name = "rid", comment = "角色id")
    private long rid;

    @Column(name = "star_reward_record", comment = "领取星级奖励")
    private Set<Integer> starRewardRecord = new HashSet<>();

    @Column(name = "can_challenge_count", comment = "可挑战次数")
    private int canChallengeCount;

    @Column(name = "buy_count", comment = "已购买次数")
    private int buyCount;

    @Column(name = "reset_time", comment = "重置时间")
    private LocalDate resetTime;

    @Column(name = "max_lv", comment = "最大关卡数")
    private int maxLevel;

    @Column(name = "sum_star", comment = "总星数")
    private int sumStar;
}
