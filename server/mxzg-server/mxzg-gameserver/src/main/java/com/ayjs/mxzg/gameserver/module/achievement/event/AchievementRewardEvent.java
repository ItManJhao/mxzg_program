package com.ayjs.mxzg.gameserver.module.achievement.event;

import lombok.Value;

/**
 * 任务领奖事件
 *
 * @Author: CWJ
 * @Date: 2019/11/25
 **/
@Value(staticConstructor = "of")
public class AchievementRewardEvent {
    private long rid;
    private int taskId;

}
