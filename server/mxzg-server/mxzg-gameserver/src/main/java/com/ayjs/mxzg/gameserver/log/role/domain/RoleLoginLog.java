package com.ayjs.mxzg.gameserver.log.role.domain;

import com.ayjs.mxzg.common.persistence.annotation.*;
import com.ayjs.mxzg.template.log.AbstractOperateLog;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Sharding(strategy = Sharding.Strategy.DATE, period = Sharding.Period.MONTHLY)
@Table(name = "role_login_log", comment = "登录日志",
        indexes = {@Index(name = "idx_rid_time", columnList = {"rid", "login_time"}),
                @Index(name = "idx_time", columnList = "login_time")})
public class RoleLoginLog extends AbstractOperateLog {

    @Column(name = "open_id", length = 128, comment = "身份标识")
    private String openid;

    @ShardingId
    @Column(name = "login_time", comment = "登录时间", readOnly = true)
    private int loginTime;

    @Column(name = "ip", comment = "登录ip", length = 15)
    private String ip;

    @Column(name = "login_type", comment = "登录客户端类型0：IOS，1：安卓")
    private int loginType;

    @Column(name = "level", comment = "等级")
    private int level;
    
    @Column(name = "born_time", comment = "玩家的创号时间")
    private int bornTime;

    @Column(name = "device_id", comment = "玩家设备id")
    private String deviceId;
}
