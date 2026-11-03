package com.ayjs.mxzg.gameserver.log.clan.domain;


import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Sharding;
import com.ayjs.mxzg.common.persistence.annotation.ShardingId;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.template.log.AbstractOperateLog;
import lombok.Getter;
import lombok.Setter;


/**
 * 公会职位改变日志
 * @author hyx
 */
@Sharding(strategy = Sharding.Strategy.DATE, period = Sharding.Period.MONTHLY)
@Table(name = "clan_job_change_log", comment = "公会职位改变日志")
@Setter
@Getter
public class ClanJobChangeLog extends AbstractOperateLog {
    @Column(name = "clan_id",comment = "公会id")
    private long clanId;

    @Column(name = "member_id",comment = "被操作人")
    private long memberId;

    @Column(name = "old_job",comment = "旧职位")
    private String oldJob;

    @Column(name = "new_job",comment = "新职位")
    private String newJob;

    @ShardingId
    @Column(name = "time",comment = "操作时间", readOnly = true)
    private int time;
}
