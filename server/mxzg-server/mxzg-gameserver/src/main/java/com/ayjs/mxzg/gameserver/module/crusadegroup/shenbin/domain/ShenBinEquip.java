package com.ayjs.mxzg.gameserver.module.crusadegroup.shenbin.domain;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.*;
import lombok.Getter;
import lombok.Setter;

/**
 * 神兵装备
 */
@Entity
@Table(name = "shenbin_equip", comment = "神兵装备槽位表", indexes = {@Index(name = "rid", columnList = {"rid"})}, cache = {@Cache(columns = "rid")})
@Getter
@Setter
public class ShenBinEquip extends AbstractEntity {
    @Id
    @Column(name = "id", comment = "主键id")
    @LongIdGenerate
    private long id;
    @Column(name = "rid", comment = "玩家ID", readOnly = true)
    private long rid;
    @Column(name = "sys_id", comment = "配置表ID")
    private int sysId;
    @Column(name = "job", comment = "职业")
    private int job;
    @Column(name = "place", comment = "部位，决定对应系统的数据类型", readOnly = true)
    private int place;//1-6


}
