package com.ayjs.mxzg.cross.log.server.domain;

import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.LongIdGenerate;
import com.ayjs.mxzg.common.persistence.annotation.Sharding;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.common.persistence.log.AbstractLog;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;
import java.util.List;

@Getter
@Setter
@Sharding(strategy = Sharding.Strategy.SINGLE)
@Table(name = "server_connect_log", comment = "服务器连接日志")
public class ServerConnectLog extends AbstractLog {
    @Id
    @LongIdGenerate
    @Column(name = "id", comment = "唯一ID")
    private long id;
    @Column(name = "server_id", comment = "服务器IDs")
    private List<Integer> serverId;
    @Column(name = "status", comment = "状态值，1连接，0断开")
    private int status;
    @Column(name = "host", comment = "地址")
    private String host = "";
    @Column(name = "op_time", comment = "操作的时间")
    private LocalDateTime opTime;

    @Override
    public Long getId() {
        return id;
    }

    @Override
    public void setId(Long id) {
        this.id = id;
    }
}
