package com.ayjs.mxzg.gameserver.log.clan.domain;

import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Sharding;
import com.ayjs.mxzg.common.persistence.annotation.ShardingId;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.template.log.AbstractOperateLog;
import lombok.Getter;
import lombok.Setter;

/**
 * 公会创建解散日志
 * @author hyx
 */
@Sharding(strategy = Sharding.Strategy.DATE, period = Sharding.Period.MONTHLY)
@Table(name = "clan_create_or_dissolution_log", comment = "公会创建解散日志")
@Setter
@Getter
public class ClanCreateOrDissolutionLog extends AbstractOperateLog {

    @Column(name = "clan_id",comment = "公会Id")
    private long clanId;

    @Column(name = "clan_name",comment = "公会昵称")
    private String clanName;

    @Column(name = "event_type",comment = "事件类型，0为创建工会，1为解散公会")
    private int eventType;

    @ShardingId
    @Column(name = "time",comment = "时间", readOnly = true)
    private int time;
}
