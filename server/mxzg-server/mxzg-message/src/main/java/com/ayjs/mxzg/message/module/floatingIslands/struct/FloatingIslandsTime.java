package com.ayjs.mxzg.message.module.floatingIslands.struct;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import lombok.Getter;
import lombok.Setter;
import lombok.extern.slf4j.Slf4j;

/**
 * @Author: CWJ
 * @Date: 2020/7/1
 **/
@Entity
@Table(name = "floating_islands_time", comment = "浮空岛时间")
@Setter
@Getter
@Slf4j
public class FloatingIslandsTime extends AbstractEntity {

    @Id
    @Column(name = "id", comment = "唯一标识")
    private long id;

    @Column(name = "stage", comment = "阶段")
    private int stage;

    @Column(name = "next_time", comment = "下一阶段时间")
    private int nextTime;

    @Column(name = "next_stage", comment = "下一阶段")
    private int nextStage;

    @Column(name = "stage_change_time", comment = "阶段改变时间")
    private int stageChangeTime;

//    @Column(name = "boss_turns", comment = "boss轮次")
//    private int bossTurns = 1;

}
