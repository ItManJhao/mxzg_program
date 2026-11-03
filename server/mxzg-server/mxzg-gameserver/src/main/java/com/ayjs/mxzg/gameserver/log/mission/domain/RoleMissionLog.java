package com.ayjs.mxzg.gameserver.log.mission.domain;

import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Sharding;
import com.ayjs.mxzg.common.persistence.annotation.ShardingId;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.template.log.AbstractOperateLog;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

@Sharding(strategy = Sharding.Strategy.DATE, period = Sharding.Period.MONTHLY)
@Table(name = "role_mission_log", comment = "主线关卡日志")
@Setter
@Getter
public class RoleMissionLog extends AbstractOperateLog {
    @Column(name = "rid_fighting", comment = "角色战力")
    private int ridFighting;
    @Column(name = "rid_level", comment = "角色等级")
    private int ridLevel;
    @Column(name = "mission_id", comment = "关卡id")
    private int missionId;
    @Column(name = "mission_name", comment = "关卡名字")
    private String missionName;
    @Column(name = "chapter_id", comment = "章节id")
    private int chapter_id;
    @Column(name = "result", comment = "结果状态输/赢")
    private boolean result;
    @Column(name = "dateTime", comment = "时间")
    private LocalDateTime dateTime;
    @ShardingId
	@Column(name = "time", comment = "日志时间", readOnly = true)
	private int time;
}
