package com.ayjs.mxzg.cross.module.teamArena.domain;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.message.module.teamArena.domain.ArenaTeamMember;
import lombok.Getter;
import lombok.Setter;

import java.util.concurrent.CopyOnWriteArrayList;

/**
 * @Author: CWJ
 * @Date: 2020/4/10
 **/
@Table(name = "cross_arena_team", comment = "跨服组队竞技场队伍")
@Getter
@Setter
@Entity
public class CrossArenaTeam extends AbstractEntity {
    @Id
    @Column(name = "team_id", comment = "唯一标识")
    private long teamId;
    @Column(name = "captain_id", comment = "队长")
    private long captainId;
    @Column(name = "team_name", comment = "队伍名字")
    private String teamName;

    @Column(name = "server_id", comment = "游戏服")
    private int serverId;

    @Column(name = "member", comment = "所有队员，包含队长，战斗顺序")
    private CopyOnWriteArrayList<ArenaTeamMember> members = new CopyOnWriteArrayList<>();

    @Column(name = "score", comment = "积分")
    private int score;

    @Column(name = "rank_time", comment = "排行榜时间")
    private int rankTime;

    @Column(name = "create_time", comment = "创建时间")
    private int createTime;
}
