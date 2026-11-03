package com.ayjs.mxzg.gameserver.module.heroArrive.domain;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.*;
import lombok.Data;

/**
 * @description:
 * @author: CWJ
 * @date: 2019/10/11 16:43
 */
@Entity
@Table(name = "task_hero_arrive", indexes = {@Index(name = "rid", columnList = {"rid"})}, cache = {@Cache(columns = "rid")})
@Data
public class TaskHeroArrive extends AbstractEntity {
    @Id
    @LongIdGenerate
    @Column(name = "id", comment = "唯一主键")
    private long id;
    @Column(name = "rid", readOnly = true, unique = true, nullable = false)
    private long rid;
    @Column(name = "idx")
    private int idx;
    @Column(name = "had_reward")
    private boolean hadReward;

}
