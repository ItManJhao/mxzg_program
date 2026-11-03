package com.ayjs.mxzg.cross.module.ladder.domain;


import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.LongIdGenerate;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;
import java.util.List;

@Entity
@Table(name = "cross_ladder_backup", comment = "跨服天梯备份")
@Getter
@Setter
public class CrossLadderBackup extends AbstractEntity {
    @Id
    @LongIdGenerate
    @Column(name = "id", comment = "主键ID")
    private int id;
    @Column(name = "group_id", comment = "跨服组ID")
    private int groupId;

    @Column(name = "ranks", length = 1024, comment = "排名数据")
    private List<CrossLadderData> ranks;

    @Column(name = "event", length = 32, comment = "备份事件")
    private String event;

    @Column(name = "update_time", comment = "排名数据")
    private LocalDateTime updateTime;
}
