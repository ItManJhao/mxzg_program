package com.ayjs.mxzg.cross.module.magicTower.domain;

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
 * @Author: CWJ
 * @Date: 2021/6/21
 **/
@Entity
@Table(name = "magic_tower_group_level", comment = "幻魔塔组关卡信息", indexes = {@Index(name = "group_id",
        columnList = {"group_id"})}, cache = {@Cache(columns = "group_id")})
@Getter
@Setter
public class MagicTowerGroupLevel extends AbstractEntity {

    @Id
    @LongIdGenerate
    @Column(name = "id", comment = "标识")
    private long id;

    @Column(name = "group_id", comment = "组id", readOnly = true)
    private int groupId;

    @Column(name = "level", comment = "关卡")
    private int level;

    @Column(name = "arena_rid", comment = "擂主")
    private long arenaRid;

    @Column(name = "min_time_rid", comment = "最少通关时间")
    private long minTimeRid;
    @Column(name = "spend_time", comment = "战斗花费时间")
    private int spendTime;
    @Column(name = "time_battle_id", comment = "最少时间战斗id")
    private String timeBattleId = "";

    @Column(name = "min_fighting_rid", comment = "最低战力玩家")
    private long minFightingRid;
    @Column(name = "min_fighting", comment = "最低战力")
    private long minFighting;
    @Column(name = "fight_battle_id", comment = "最低战力战斗id")
    private String fightBattleId = "";

}
