package com.ayjs.mxzg.gameserver.log.weeksCard.domain;


import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Sharding;
import com.ayjs.mxzg.common.persistence.annotation.ShardingId;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.template.log.AbstractOperateLog;
import lombok.Getter;
import lombok.Setter;

@Sharding(strategy = Sharding.Strategy.DATE, period = Sharding.Period.MONTHLY)
@Table(name = "weeks_card_log", comment = "周卡日志")
@Setter
@Getter
public class WeeksCardLog extends AbstractOperateLog {

    @Column(name = "card_id", comment = "周卡道具类型")
    private long cardId;
    @Column(name = "item_type", comment = "周卡道具类型")
    private int itemType;
    @Column(name = "active_time", comment = "激活时间")
    private int activeTime;
    @Column(name = "end_time", comment = "结束时间")
    private int endTime;
    @ShardingId
    @Column(name = "time", comment = "日志时间", readOnly = true)
    private int time;
}
