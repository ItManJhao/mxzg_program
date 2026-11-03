package com.ayjs.mxzg.gameserver.module.dailydungeon.domain;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Cache;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Index;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.gameserver.module.dailydungeon.constant.DailyDungeonModel;
import lombok.Data;

import java.util.Map;

@Data
@Table(name = "daily_dungeon", comment = "每日副本表", indexes = {@Index(name = "rid", columnList = {"rid"})},
        cache = {@Cache(columns = "rid")})
@Entity
public class DailyDungeon extends AbstractEntity {

    @Id
    @Column(name = "rid", readOnly = true)
    private long rid;

    @Column(name = "dungeon_type", length = 500)
    private Map<Integer, DailyDungeonModel> dungeonMap;

}
