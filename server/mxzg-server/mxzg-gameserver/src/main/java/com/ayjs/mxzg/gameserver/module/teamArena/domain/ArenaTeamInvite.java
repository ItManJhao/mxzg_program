package com.ayjs.mxzg.gameserver.module.teamArena.domain;

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
 * @Date: 2020/4/9
 **/
@Table(name = "arena_team_invite", comment = "组队竞技场邀请信息", cache = {@Cache(columns = "invite_id"), @Cache(columns = "team_id")},
        indexes = {@Index(name = "team_id", columnList = {"team_id"}), @Index(name = "invite_id", columnList = {"invite_id"})})
@Getter
@Setter
@Entity
public class ArenaTeamInvite extends AbstractEntity {

    @Id
    @LongIdGenerate
    @Column(name = "id", comment = "唯一标识")
    private long id;

    @Column(name = "invite_id", comment = "被邀请者", readOnly = true)
    private long inviteId;

    @Column(name = "team_id", comment = "队伍id", readOnly = true)
    private long teamId;

    @Column(name = "invite_time", comment = "邀请时间")
    private int inviteTime;

}
