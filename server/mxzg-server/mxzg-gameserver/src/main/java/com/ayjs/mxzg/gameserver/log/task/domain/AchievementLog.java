package com.ayjs.mxzg.gameserver.log.task.domain;

import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.template.log.AbstractOperateLog;
import lombok.Getter;
import lombok.Setter;

/**
 * @Author: CWJ
 * @Date: 2019/11/25
 **/
//@Sharding(strategy = Sharding.Strategy.DATE, period = Sharding.Period.MONTHLY)
@Table(name = "achievement_log", comment = "成就完成日志表")
@Setter
@Getter
public class AchievementLog extends AbstractOperateLog {
    @Column(name = "task_id", comment = "配置id")
    private long taskId;
    @Column(name = "reward_time")
    private int rewardTime;
}
