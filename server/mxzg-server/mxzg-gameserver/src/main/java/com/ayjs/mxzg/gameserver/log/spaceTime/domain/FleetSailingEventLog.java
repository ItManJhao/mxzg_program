package com.ayjs.mxzg.gameserver.log.spaceTime.domain;


import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Sharding;
import com.ayjs.mxzg.common.persistence.annotation.ShardingId;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.template.log.AbstractOperateLog;
import lombok.Getter;
import lombok.Setter;

@Sharding(strategy = Sharding.Strategy.DATE, period = Sharding.Period.MONTHLY)
@Table(name = "fleet_sailing_event_log", comment = "舰队航行事件日志")
@Getter
@Setter
public class FleetSailingEventLog extends AbstractOperateLog {


    @Column(name = "route",comment = "所处航线")
    private int route;

    @Column(name = "event_id",comment = "所遇事件")
    private int eventId;

    @Column(name = "event_desc",comment = "事件描述")
    private String eventDesc;

    @ShardingId
    @Column(name = "time", comment = "日志时间", readOnly = true)
    private int time;
}
