package com.ayjs.mxzg.template.scheduler.domain;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Cache;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Index;
import com.ayjs.mxzg.common.persistence.annotation.Index.IndexType;
import com.ayjs.mxzg.common.persistence.annotation.LongIdGenerate;
import com.ayjs.mxzg.common.persistence.annotation.Sharding;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

/**
 * 定时任务备份
 */
@Getter
@Setter
@Sharding
@Table(name = "cron_task_backup", comment = "定时任务备份", indexes = {
        @Index(name = "identity", columnList = {"identity"}, type = IndexType.UNIQUE)}, cache = {
        @Cache(columns = "identity")})
public class CronTaskBackup extends AbstractEntity {

    @Id
    @LongIdGenerate
    @Column(name = "id")
    private long id;
    @Column(name = "identity", comment = "任务唯一标识", length = 128, readOnly = true)
    private String identity;

    @Column(name = "expression", comment = "cron表达式", length = 64)
    private String expression;

    @Column(name = "last_scheduled_execution_time", comment = "计划执行时间", nullable = false)
    private LocalDateTime lastScheduledExecutionTime;

    @Column(name = "last_actual_execution_time", comment = "实际执行时间", nullable = false)
    private LocalDateTime lastActualExecutionTime;

    @Column(name = "last_completion_execution_time", comment = "完成时间", nullable = false)
    private LocalDateTime lastCompletionTime;
}
