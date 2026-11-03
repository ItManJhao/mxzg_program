package com.ayjs.mxzg.gameserver.module.promotionNew.domain;

import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import lombok.Getter;
import lombok.Setter;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

/**
 * 每日登陆
 *
 * @author hyx
 */
@Getter
@Setter
@Entity
@Table(name = "promotion057_every_day_login", comment = "每日登陆")
public class Promotion057EveryDayLogin extends BaseLoopingPromotion {

    @Column(name = "daily_time",comment = "上一次重置任务时间")
    private int dailyTime;

    @Column(name = "task_list",comment = "任务列表,<idx,progress>")
    private Map<Integer,Integer> taskList = new HashMap<>();

    @Column(name = "task_reward",comment = "领取的任务奖励")
    private Set<Integer> taskReward = new HashSet<>();

}
