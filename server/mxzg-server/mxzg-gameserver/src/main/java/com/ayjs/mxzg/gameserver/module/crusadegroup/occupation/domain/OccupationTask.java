package com.ayjs.mxzg.gameserver.module.crusadegroup.occupation.domain;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.*;
import lombok.Getter;
import lombok.Setter;

/**
 * 角色职级任务表
 */
@Entity
@Table(name = "occupation_task", comment = "角色职级任务表", indexes = {@Index(name = "rid", columnList = {"rid"}),@Index(name = "taskId", columnList = {"taskId"})}, cache = {@Cache(columns = "rid"),@Cache(columns = "taskId")})
@Getter
@Setter
public class OccupationTask extends AbstractEntity {

    @Id
    @Column(name = "id", comment = "主键id")
    @LongIdGenerate
    private long id;
    @Column(name = "rid", comment = "玩家ID", readOnly = true)
    private long rid;
    @Column(name = "taskId", readOnly = true)
    private int taskId;//对应COccupationTaskTemplate  id
    @Column(name = "count", nullable = false, length = 10)
    private long count;//计数
    @Column(name = "condition", comment = "条件是否满足")
    private int condition;//-1：为不满足条件 0：满足条件（针对特殊任务，比如 是否参与击杀boss）
    @Column(name = "complete_type", comment = "玩家手动完成状态")
    private int complete_type;//-1：没有手动完成 0：已经手动完成

    public void addCount(long addC){
        count +=addC;
    }
}
