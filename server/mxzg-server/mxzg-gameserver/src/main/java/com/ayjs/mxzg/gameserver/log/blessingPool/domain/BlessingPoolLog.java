package com.ayjs.mxzg.gameserver.log.blessingPool.domain;

import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Sharding;
import com.ayjs.mxzg.common.persistence.annotation.ShardingId;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.template.log.AbstractOperateLog;
import lombok.Getter;
import lombok.Setter;

/**
 * 许愿池抽奖日志
 * @author hyx
 */
@Sharding(strategy = Sharding.Strategy.DATE, period = Sharding.Period.MONTHLY)
@Table(name = "blessing_pool_log", comment = "许愿池抽奖日志")
@Setter
@Getter
public class BlessingPoolLog extends AbstractOperateLog {
    @Column(name = "pool_type", comment = "许愿池类型 1常规 2高级")
    private int poolType;
    @Column(name = "num",comment = "抽奖次数")
    private int num;
    @ShardingId
    @Column(name = "time", comment = "日志时间", readOnly = true)
    private int time;
}
