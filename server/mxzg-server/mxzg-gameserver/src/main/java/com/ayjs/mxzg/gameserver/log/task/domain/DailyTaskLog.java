package com.ayjs.mxzg.gameserver.log.task.domain;

import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Sharding;
import com.ayjs.mxzg.common.persistence.annotation.ShardingId;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.template.log.AbstractOperateLog;
import lombok.Getter;
import lombok.Setter;

/**
 * @Author: CWJ
 * @Date: 2019/11/25
 **/
@Sharding(strategy = Sharding.Strategy.DATE, period = Sharding.Period.MONTHLY)
@Table(name = "daily_task_log", comment = "日常任务完成日志表")
@Setter
@Getter
public class DailyTaskLog extends AbstractOperateLog {
    @Column(name = "task_id", comment = "配置id")
    private long taskId;
    @ShardingId
    @Column(name = "reward_time", readOnly = true, comment = "任务完成时间")
    private int rewardTime;
}
