package com.ayjs.mxzg.gameserver.module.pet.domain;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Cache;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Index;
import com.ayjs.mxzg.common.persistence.annotation.LongIdGenerate;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import lombok.Getter;
import lombok.Setter;


/**
 * @author hyx
 */
@Entity
@Table(name = "pet", comment = "宠物表", indexes = {@Index(name = "rid", columnList = {"rid"})}, cache = {@Cache(columns = "rid")})
@Getter
@Setter
public class Pet extends AbstractEntity {

    @Id
    @Column(name = "id", comment = "主键id")
    @LongIdGenerate
    private long id;

    @Column(name = "rid", comment = "玩家id", readOnly = true)
    private long rid;

    @Column(name = "sys_id", comment = "道具id")
    private int sysId;

    @Column(name = "hero_id", comment = "携带的英雄id")
    private long heroId;

    @Column(name = "level", comment = "宠物等级")
    private int level;
}
