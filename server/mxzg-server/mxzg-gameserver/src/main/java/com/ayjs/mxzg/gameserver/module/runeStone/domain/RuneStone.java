package com.ayjs.mxzg.gameserver.module.runeStone.domain;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Cache;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Index;
import com.ayjs.mxzg.common.persistence.annotation.LongIdGenerate;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.gameserver.module.runeStone.struct.RuneStoneExtraGrid;
import lombok.Getter;
import lombok.Setter;

import java.util.HashMap;
import java.util.Map;

/**
 * @Author: CWJ
 * @Date: 2020/7/29
 **/
@Getter
@Setter
@Entity
@Table(name = "rune_stone", comment = "符石", indexes = {@Index(name = "rid", columnList = {"rid"})}, cache = {@Cache(columns = "rid")})
public class RuneStone extends AbstractEntity {

    @LongIdGenerate
    @Id
    @Column(name = "id", comment = "唯一标识")
    private long id;

    @Column(name = "rid", comment = "角色id", readOnly = true)
    private long rid;

    @Column(name = "idx", comment = "符石配置id")
    private int idx;

    @Column(name = "hero_id", comment = "装备英雄")
    private long heroId;
    @Column(name = "place", comment = "装备位置")
    private int place;

    @Column(name = "extra_grid", comment = "资质格子")
    private Map<Integer, RuneStoneExtraGrid> extraGrid = new HashMap<>();

    @Column(name = "lock", comment = "是否锁定")
    private boolean lock;

    public void equip(int place, long heroId) {
        this.heroId = heroId;
        this.place = place;
    }

    public RuneStoneExtraGrid getGridByPlace(int place) {
        return extraGrid.get(place);
    }

}
