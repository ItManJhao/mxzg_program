package com.ayjs.mxzg.gameserver.module.crusadegroup.shenbin.domain;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.*;
import lombok.Getter;
import lombok.Setter;

/**
 * 神兵核心
 */
@Entity
@Table(name = "shenbin_core", comment = "神兵核心表", indexes = {@Index(name = "rid", columnList = {"rid"})}, cache = {@Cache(columns = "rid")})
@Getter
@Setter
public class ShenBinCore extends AbstractEntity {
    @Id
    @Column(name = "id", comment = "主键id")
    @LongIdGenerate
    private long id;
    @Column(name = "rid", comment = "玩家ID", readOnly = true)
    private long rid;
    @Column(name = "job", comment = "职业")
    private int job;
    @Column(name = "coreLv", comment = "核心等级")
    private int coreLv;
}
