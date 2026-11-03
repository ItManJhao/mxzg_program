package com.ayjs.mxzg.gameserver.module.countryWar.domain;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;

/**
 * @Author: CWJ
 * @Date: 2021/4/19
 **/
@Entity
@Table(name = "country_war", comment = "国战")
@Getter
@Setter
public class CountryWar extends AbstractEntity {
    @Id
    @Column(name = "rid", comment = "角色id")
    private long rid;
    @Column(name = "round", comment = "轮次")
    private int round;
    @Column(name = "city_reward_count", comment = "城池领奖次数")
    private Map<Integer, Integer> cityRewardCount = new ConcurrentHashMap<>();
    @Column(name = "event_reward_count", comment = "事件领奖次数")
    private Map<Integer, Integer> eventRewardCount = new ConcurrentHashMap<>();

    @Column(name = "attack_item_num", comment = "上次攻击令增加时间")
    private int attackItemNum;
    @Column(name = "last_attack_add", comment = "上次攻击令增加时间")
    private LocalDateTime lastAttackAdd = LocalDateTime.of(1970, 1, 1, 0, 0);
    @Column(name = "move_item_num", comment = "上次攻击令增加时间")
    private int moveItemNum;
    @Column(name = "last_move_add", comment = "上次攻击令增加时间")
    private LocalDateTime lastMoveAdd = LocalDateTime.of(1970, 1, 1, 0, 0);

    @Column(name = "score_mission", comment = "积分任务")
    private Map<Integer, CountryWarScoreMission> scoreMission = new ConcurrentHashMap<>();
    @Column(name = "score_reward", comment = "积分领奖")
    private Set<Integer> scoreReward = new HashSet<>();
    @Column(name = "score_mystery_reward", comment = "积分领奖")
    private Set<Integer> scoreMysteryReward = new HashSet<>();
    @Column(name = "score", comment = "积分")
    private int score;
    @Column(name = "buy_mystery", comment = "购买积分神秘礼物")
    private boolean buyMystery;
    @Column(name = "mystery_day", comment = "购买道具后，每日奖励时间")
    private LocalDate mysteryDay = LocalDate.of(1970, 1, 1);

    @Column(name = "lottery_count", comment = "本轮抽奖次数")
    private int lotteryCount;

    @Column(name = "flag_round", comment = "战旗任务完成轮次")
    private int flagRound;
    @Column(name = "flag_mission_count", comment = "战旗任务记数")
    private Map<Integer, Long> flagMissionCount = new ConcurrentHashMap<>();
    @Column(name = "flag_mission_reward", comment = "战旗任务领奖")
    private Map<Integer, Boolean> flagMissionReward = new ConcurrentHashMap<>();
    @Column(name = "flag_round_reward", comment = "战旗轮次领奖")
    private Set<Integer> flagRoundReward = new HashSet<>();
    @Column(name = "flag_add", comment = "战旗任务登入时间记录")
    private LocalDate flagLogin = LocalDate.of(1970, 1, 1);
    @Column(name = "shop_refresh_time", comment = "随机商店刷新时间")
    private LocalDate shopRefreshTime = LocalDate.of(1970, 1, 1);
    @Column(name = "shop_buy_count", comment = "随机商店刷新时间")
    private Map<Integer, Integer> shopBuyCount = new HashMap<>();


    public void addFlagCount(int id, long add) {
        flagMissionCount.put(id, flagMissionCount.getOrDefault(id, 0l) + add);
    }

    public void setFlagCount(int id, long setValue) {
        flagMissionCount.put(id, setValue);
    }

    public long getFlagCount(int id) {
        return flagMissionCount.getOrDefault(id, 0l);
    }
}
