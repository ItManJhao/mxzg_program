package com.ayjs.mxzg.gameserver.log.clan.domain;


import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Sharding;
import com.ayjs.mxzg.common.persistence.annotation.ShardingId;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.template.log.AbstractOperateLog;
import lombok.Getter;
import lombok.Setter;

/**
 * 公会成员改变日志
 * @author hyx
 */
@Sharding(strategy = Sharding.Strategy.DATE, period = Sharding.Period.MONTHLY)
@Table(name = "clan_member_change_log", comment = "公会成员改变日志")
@Setter
@Getter
public class ClanMemberChangeLog extends AbstractOperateLog {

    @Column(name = "clan_id",comment = "公会id")
    private long clanId;

    @Column(name = "event_type",comment = "操作类型,1为退出公会，0为加入公会")
    private int eventType;

    @ShardingId
    @Column(name = "time", comment = "操作时间", readOnly = true)
    private int time;
}
