package com.ayjs.mxzg.gameserver.module.totems.domain;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.*;
import lombok.Getter;
import lombok.Setter;

/**
 * 图腾
 */
@Entity
@Table(name = "totems", comment = "图腾表", indexes = {@Index(name = "rid", columnList = {"rid"})}, cache = {@Cache(columns = "rid")})
@Getter
@Setter
public class Totems extends AbstractEntity {

    @Id
    @Column(name = "id", comment = "主键id")
    @LongIdGenerate
    private long id;

    @Column(name = "rid", comment = "玩家id", readOnly = true)
    private long rid;

    @Column(name = "totems_id", comment = "图腾道具id")
    private int totems_id;

    @Column(name = "hero_id", comment = "穿戴的英雄id，<=0表示没有穿戴")
    private long heroId;

    @Column(name = "level", comment = "图腾等级")
    private int level;

    @Column(name = "quality", comment = "图腾品质")
    private int quality;
}
