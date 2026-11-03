package com.ayjs.mxzg.gameserver.module.reikiEquip.domain;

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


@Entity
@Table(name = "reiki_equip", comment = "灵器数据",
        indexes = {@Index(name = "rid", columnList = {"rid"})}, cache = {@Cache(columns = "rid")})
@Getter
@Setter
public class ReikiEquip extends AbstractEntity {

    @Id
    @LongIdGenerate
    @Column(name = "id", comment = "唯一ID")
    private long id;

    @Column(name = "sys_id", comment = "配置表灵器id")
    private int sysId;

    @Column(name = "rid", comment = "玩家ID", readOnly = true)
    private long rid;

    @Column(name = "hero_id", comment = "英雄ID")
    private long heroId;
}
