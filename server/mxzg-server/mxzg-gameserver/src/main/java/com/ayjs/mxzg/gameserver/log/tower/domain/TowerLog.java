package com.ayjs.mxzg.gameserver.log.tower.domain;

import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Sharding;
import com.ayjs.mxzg.common.persistence.annotation.ShardingId;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.template.log.AbstractOperateLog;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

@Sharding(strategy = Sharding.Strategy.DATE, period = Sharding.Period.MONTHLY)
@Table(name = "tower_log", comment = "幻境之塔日志")
@Setter
@Getter
public class TowerLog extends AbstractOperateLog {
    @Column(name = "rid_fighting", comment = "角色战力")
    private int ridFighting;
    @Column(name = "rid_level", comment = "角色等级")
    private int ridLevel;
    @Column(name = "stage", comment = "挑战的层")
    private int stage;
    @Column(name = "stage_fighting", comment = "当前层的战力")
    private int stageFighting;
    @Column(name = "result", comment = "结果状态输/赢")
    private boolean result;
    @Column(name = "dateTime", comment = "时间")
    private LocalDateTime dateTime;
    @ShardingId
	@Column(name = "time", comment = "日志时间", readOnly = true)
	private int time;
}
