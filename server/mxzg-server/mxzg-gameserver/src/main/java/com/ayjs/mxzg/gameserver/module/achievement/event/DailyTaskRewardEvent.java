package com.ayjs.mxzg.gameserver.module.achievement.event;

import lombok.Value;

/**
 * 每日任务领取奖励
 * @author hyx
 */
@Value(staticConstructor = "of")
public class DailyTaskRewardEvent {

    private long rid;

    private int idx;//任务配置表idx

    private int point;//积分数

}
