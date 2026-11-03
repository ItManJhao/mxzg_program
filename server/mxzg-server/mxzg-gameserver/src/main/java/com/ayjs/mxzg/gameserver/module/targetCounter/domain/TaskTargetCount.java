package com.ayjs.mxzg.gameserver.module.targetCounter.domain;

/**
 * @Author: CWJ
 * @Date: 2019/11/13
 **/

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Cache;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Index;
import com.ayjs.mxzg.common.persistence.annotation.LongIdGenerate;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import lombok.Data;
import lombok.extern.slf4j.Slf4j;

/**
 * @description: 玩家任务目标累计计数
 * @author: CWJ
 * @date: 2019/10/14 10:10
 */
@Entity
@Table(name = "task_target_count", indexes = {@Index(name = "rid", columnList = {"rid"})}, cache = {@Cache(columns = "rid")})
@Data
@Slf4j
public class TaskTargetCount extends AbstractEntity {

    @Id
    @LongIdGenerate
    @Column(name = "id", comment = "唯一主键")
    private long id;
    @Column(name = "rid", readOnly = true, nullable = false, length = 19)
    private long rid;
    /**
     * {@link com.ayjs.mxzg.config.struct.TargetType}
     */
    @Column(name = "type")
    private int type;
    @Column(name = "condition")
    private int condition;
    @Column(name = "sub_condition")
    private int subCondition;

    /**
     * 计数
     */
    @Column(name = "count", nullable = false, length = 10)
    private long count;

    public long addProcess(long addValue) {
        return this.count += addValue;
    }

}
