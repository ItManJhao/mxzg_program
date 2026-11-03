package com.ayjs.mxzg.gameserver.module.promotionNew.domain;

import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import lombok.Data;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;


/**
 * 七日目标（从功能转为开服循环活动）
 * @author hyx
 */
@Entity
@Table(name = "promotion018_seven_day_target", comment = "七日目标")
@Data
public class Promotion018SevenDayTarget extends BaseLoopingPromotion {

    @Column(name = "task_list",comment = "任务列表,<idx,progress>")
    private Map<Integer,Integer> task_list = new HashMap<>();

    @Column(name = "task_reward",comment = "领取的任务奖励")
    private Set<Integer> taskReward = new HashSet<>();

    @Column(name = "box_rewards", comment = "七日目标宝箱领取记录")
    private Set<Integer> boxRewards = new HashSet<>();

    /*@Column(name = "status",comment = "是否继承原七日目标数据")
    private int status;*/
}
