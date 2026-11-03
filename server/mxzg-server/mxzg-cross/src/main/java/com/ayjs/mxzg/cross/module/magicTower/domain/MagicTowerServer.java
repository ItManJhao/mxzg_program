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
 * @Date: 2021/6/19
 **/
@Entity
@Table(name = "magic_tower_server", comment = "幻魔塔服务器关卡信息，只记录擂主关", indexes = {@Index(name = "server_id",
        columnList = {"server_id"})}, cache = {@Cache(columns = "server_id")})
@Getter
@Setter
public class MagicTowerServer extends AbstractEntity {

    @Id
    @LongIdGenerate
    @Column(name = "id", comment = "服务器id")
    private long id;

    @Column(name = "server_id", comment = "服务器id", readOnly = true)
    private int serverId;

    @Column(name = "level", comment = "关卡", readOnly = true)
    private int level;

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
