package com.ayjs.mxzg.gameserver.log.spaceTime.domain;

import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Sharding;
import com.ayjs.mxzg.common.persistence.annotation.ShardingId;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.template.log.AbstractOperateLog;
import lombok.Getter;
import lombok.Setter;
import org.springframework.data.annotation.Id;


@Sharding(strategy = Sharding.Strategy.DATE, period = Sharding.Period.MONTHLY)
@Table(name = "fleet_sailing_log", comment = "舰队航行日志")
@Getter
@Setter
public class FleetSailingLog extends AbstractOperateLog {

    @Column(name= "type",comment = "操作类型，0起航，1结束航行")
    private int type;

    @ShardingId
    @Column(name = "time", comment = "日志时间", readOnly = true)
    private int time;

}
