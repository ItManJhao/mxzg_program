package com.ayjs.mxzg.gameserver.module.achievement.domain;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.*;
import lombok.Data;

/**
 * @description:
 * @author: CWJ
 * @date: 2019/10/12 16:46
 */
@Table(name = "daily_task", comment = "每日任务表", indexes = {@Index(name = "rid", columnList = {"rid"})}, cache = {@Cache(columns = "rid")})
@Entity
@Data
public class DailyTask extends AbstractEntity {
    @Id
    @LongIdGenerate
    @Column(name = "id", comment = "唯一主键")
    private long id;
    @Column(name = "rid", unique = true, nullable = false, length = 19, readOnly = true)
    private long rid;

    /**
     * 目标类型
     * {@link }
     */
    @Column(name = "task_id", unique = true, nullable = false, length = 10)
    private int taskId;

    /**
     * 进度
     */
    @Column(name = "progress", nullable = false, length = 10)
    private int progress;

    @Column(name = "had_reward", nullable = false, length = 3)
    private int hadReward;
    /**
     * 上次操作时间
     */
    @Column(name = "last_time", nullable = false, length = 19)
    private long lastTime;


}
