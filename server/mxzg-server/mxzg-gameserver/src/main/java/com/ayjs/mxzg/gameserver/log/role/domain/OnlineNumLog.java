package com.ayjs.mxzg.gameserver.log.role.domain;

import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.LongIdGenerate;
import com.ayjs.mxzg.common.persistence.annotation.Sharding;
import com.ayjs.mxzg.common.persistence.annotation.ShardingId;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.common.persistence.log.AbstractLog;

import lombok.Getter;
import lombok.Setter;

/**
 * @Author: CWJ
 * @Date: 2019/12/13
 **/
@Sharding(strategy = Sharding.Strategy.DATE, period = Sharding.Period.MONTHLY)
@Table(name = "online_num_log", comment = "在线人数日志")
@Getter
@Setter
public class OnlineNumLog extends AbstractLog {
    @Id(auto = false)
    @LongIdGenerate
    @Column(name = "id", comment = "主键")
    private long id;
    @Column(name = "server_id", comment = "服务器id")
    private int serverId;
    @Column(name = "online_num", comment = "在线人数")
    private int onlineNum;
    @Column(name = "distinct_online_num", comment = "ip去在线人数")
    private int distinctOnlineNum;
    @ShardingId
    @Column(name = "record_time", comment = "记录时间",readOnly = true)
    private int recordTime;
    @Column(name = "place",comment = "渠道id")
    private int place ;

    @Override
    public Long getId() {
        return id;
    }

    @Override
    public void setId(Long id) {
        this.id = id;
    }
}
