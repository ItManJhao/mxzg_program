package com.ayjs.mxzg.gameserver.module.teamArena.domain;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Cache;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Index;
import com.ayjs.mxzg.common.persistence.annotation.LongIdGenerate;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.message.module.teamArena.domain.TeamArenaRankData;
import lombok.Getter;
import lombok.Setter;

/**
 * @Author: CWJ
 * @Date: 2020/4/9
 **/
@Table(name = "arena_team_record", comment = "组队竞技场队伍", indexes = {@Index(name = "team_id", columnList = {"team_id"})},
        cache = {@Cache(columns = "team_id")})
@Getter
@Setter
@Entity
public class ArenaTeamBattleRecord extends AbstractEntity {

    @Id
    @LongIdGenerate
    @Column(name = "id")
    private long id;

    @Column(name = "team_id", readOnly = true)
    private long teamId;

    @Column(name = "win_team", comment = "胜利者")
    private long winTeamId;
    @Column(name = "add_score", comment = "攻击方增加分数")
    private int addScore;
    @Column(name = "add_rank", comment = "攻击方增加排名")
    private int addRank;
    @Column(name = "battle_time", comment = "战斗时间")
    private int battleTime;
    @Column(name = "defend_add_rank", comment = "防守方增加排名")
    private int defendAddRank;
    @Column(name = "defend_reduce_score", comment = "防守方减少分数")
    private int defendReduceScore;

    @Column(name = "attack", comment = "攻击方")
    private TeamArenaRankData attack = new TeamArenaRankData();
    @Column(name = "defend", comment = "防守方")
    private TeamArenaRankData defend = new TeamArenaRankData();


}
