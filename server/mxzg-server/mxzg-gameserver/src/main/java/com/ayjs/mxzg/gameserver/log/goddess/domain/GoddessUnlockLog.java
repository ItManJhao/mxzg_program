package com.ayjs.mxzg.gameserver.log.goddess.domain;

import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Sharding;
import com.ayjs.mxzg.common.persistence.annotation.ShardingId;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.template.log.AbstractOperateLog;
import lombok.Getter;
import lombok.Setter;


/**
 * 羈絆女神解鎖日誌
 * @author hyx
 */
@Sharding(strategy = Sharding.Strategy.DATE, period = Sharding.Period.MONTHLY)
@Table(name = "goddess_unlock_log", comment = "羁绊女神解锁日志")
@Setter
@Getter
public class GoddessUnlockLog extends AbstractOperateLog {

    @Column(name = "goddess_type",comment = "解锁的女神id")
    private long goddessType;

    @ShardingId
    @Column(name = "time",comment = "时间", readOnly = true)
    private int time;

}