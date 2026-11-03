package com.ayjs.mxzg.gameserver.module.promotionNew.promotion097.domain;

import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.BaseLoopingPromotion;
import com.ayjs.mxzg.gameserver.module.promotionNew.struct.MissionInfo;
import lombok.Getter;
import lombok.Setter;

import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

/**
 * @author Rondo
 * @Date 2021-04-14 17:10:18
 */
@Entity
@Table(name = "promotion097", comment = "五一抽奖")
@Getter
@Setter
public class Promotion097 extends BaseLoopingPromotion {

    @Column(name = "cur_round", comment = "当前轮次")
    private int curRound;
    @Column(name = "left_reset_times", comment = "剩余的重置次数")
    private int leftResetTime;
    @Column(name = "times", comment = "当前轮次的第几次抽奖")
    private int times;
    @Column(name = "round_reward_map", comment = "每个轮次领取的奖励")
    private Map<Integer, Set<Integer>> rewardRecordMap = new HashMap<>();
    @Column(name = "choice_rewards", comment = "玩家当前轮次所选的奖励(位置，道具id)")
    private Map<Integer, Integer> choiceRewardMap = new HashMap<>();
}
