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
@Table(name = "arena_team_apply", comment = "组队竞技场申请信息", cache = {@Cache(columns = "apply_id"), @Cache(columns = "team_id")},
        indexes = {@Index(name = "team_id", columnList = {"team_id"}), @Index(name = "apply_id", columnList = {"apply_id"})})
@Getter
@Setter
@Entity
public class ArenaTeamApply extends AbstractEntity {

    @Id
    @LongIdGenerate
    @Column(name = "id", comment = "唯一标识")
    private long id;

    @Column(name = "apply_id", comment = "申请者", readOnly = true)
    private long applyId;

    @Column(name = "team_id", comment = "队伍id", readOnly = true)
    private long teamId;

    @Column(name = "apply_time", comment = "申请时间")
    private int applyTime;

}
