package com.ayjs.mxzg.gameserver.module.achievement.domain;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Cache;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Index;
import com.ayjs.mxzg.common.persistence.annotation.LongIdGenerate;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import lombok.Data;

/**
 * 成就任务
 *
 * @description:
 * @author: CWJ
 * @date: 2019/10/11 16:43
 */
@Entity
@Table(name = "task_achievement_test", indexes = {@Index(name = "rid", columnList = {"rid"})}, cache = {@Cache(columns = "rid")})
@Data
public class TaskAchievementTest extends AbstractEntity {
    @Id
    @LongIdGenerate
    @Column(name = "id", comment = "唯一主键")
    private long id;
    @Column(name = "rid", readOnly = true, unique = true, nullable = false)
    private long rid;

    @Column(name = "curr_task", comment = "当前任务")
    private int currTask;

    @Column(name = "had_reward", comment = "是否领奖")
    private int hadReward;

}
