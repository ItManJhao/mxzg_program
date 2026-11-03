package com.ayjs.mxzg.gameserver.module.promotionNew.domain;

import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import lombok.Data;
import lombok.Getter;
import lombok.Setter;

import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

/**
 * 三日任务表
 * @author hyx
 */
@Entity
@Table(name = "promotion061_three_day_task", comment = "三日任务")
@Getter
@Setter
public class Promotion061ThreeDayTask extends BaseLoopingPromotion {

    @Column(name = "task_list",comment = "任务列表,<idx,progress>")
    private Map<Integer,Long> taskList = new HashMap<>();

    @Column(name = "task_reward",comment = "领取的任务奖励")
    private Set<Integer> taskReward = new HashSet<>();

    @Column(name = "ultimate_reward",comment = "已领取的终极奖励")
    private Set<Integer> ultimateReward = new HashSet<>();
}
