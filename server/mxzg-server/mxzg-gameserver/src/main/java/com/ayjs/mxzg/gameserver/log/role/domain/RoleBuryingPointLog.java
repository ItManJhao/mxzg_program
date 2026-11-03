package com.ayjs.mxzg.gameserver.log.role.domain;

import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.template.log.AbstractOperateLog;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

@Setter
@Getter
@Table(name = "role_burying_point_log", comment = "玩家指引数据埋点")
public class RoleBuryingPointLog extends AbstractOperateLog {
    @Column(name = "idx", comment = "指引id")
    private int idx;
    @Column(name = "cur_start_time", comment = "当前指引开始时间")
    private LocalDateTime curStartTime;
    @Column(name = "last_guide_time", comment = "上个指引的结束时间")
    private LocalDateTime lastGuideTime;
    @Column(name = "stay_time", comment = "停留时间")
    private long stayTime;
}
