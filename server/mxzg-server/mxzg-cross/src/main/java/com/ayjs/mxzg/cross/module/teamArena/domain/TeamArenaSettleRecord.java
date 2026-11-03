package com.ayjs.mxzg.cross.module.teamArena.domain;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Cache;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Index;
import com.ayjs.mxzg.common.persistence.annotation.LongIdGenerate;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.message.module.teamArena.domain.TeamArenaRankData;
import lombok.Getter;
import lombok.Setter;

import java.util.ArrayList;
import java.util.List;

/**
 * @Author: CWJ
 * @Date: 2020/4/11
 **/
@Getter
@Setter
@Table(name = "team_arena_settle_record", comment = "结算时的排名",
        indexes = {@Index(name = "server_id", columnList = {"server_id"})}, cache = {@Cache(columns = "server_id")})
public class TeamArenaSettleRecord extends AbstractEntity {
    @Id
    @LongIdGenerate
    @Column(name = "id", comment = "标识")
    private long id;

    @Column(name = "server_id", comment = "组id", readOnly = true)
    private int serverId;
    @Column(name = "group_id", comment = "所属组")
    private int groupId;

    @Column(name = "settle_time", comment = "结算时间")
    private int settleTime;

    @Column(name = "ranks", comment = "排名数据")
    private List<TeamArenaRankData> ranks = new ArrayList<>();

}
