package com.ayjs.mxzg.gameserver.module.magicTower.domain;

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

import java.util.ArrayList;
import java.util.List;

/**
 * @Author: CWJ
 * @Date: 2021/6/18
 **/
@Table(name = "magic_tower_level", comment = "幻魔塔通关信息",
        indexes = {@Index(name = "rid", columnList = {"rid"})}, cache = {@Cache(columns = "rid")})
@Getter
@Setter
@Entity
public class MagicTowerLevel extends AbstractEntity {
    @Id
    @LongIdGenerate
    @Column(name = "id", comment = "唯一标识")
    private long id;

    @Column(name = "rid", comment = "角色id", readOnly = true)
    private long rid;

    @Column(name = "level", comment = "关卡等级")
    private int level;

    @Column(name = "spend_time", comment = "花费时间")
    private int spendTime;
    @Column(name = "battle_id", comment = "战报id")
    private String battleId = "";

    @Column(name = "complete_target", comment = "通关条件集合", length = 1024)
    private List<Integer> completeTarget = new ArrayList<>(3);
}
