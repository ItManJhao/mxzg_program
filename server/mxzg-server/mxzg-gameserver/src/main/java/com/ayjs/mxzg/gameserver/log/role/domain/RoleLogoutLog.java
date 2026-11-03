package com.ayjs.mxzg.gameserver.log.role.domain;

import com.ayjs.mxzg.common.persistence.annotation.*;
import com.ayjs.mxzg.template.log.AbstractOperateLog;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Sharding(strategy = Sharding.Strategy.DATE, period = Sharding.Period.MONTHLY)
@Table(name = "role_logout_log", comment = "登录日志",
        indexes = {@Index(name = "idx_rid_time", columnList = {"rid", "logout_time"}),
                @Index(name = "idx_time", columnList = "logout_time")})
public class RoleLogoutLog extends AbstractOperateLog {
    @Column(name = "open_id", length = 128, comment = "身份标识")
    private String openid;

    @ShardingId
    @Column(name = "logout_time", comment = "登出时间", readOnly = true)
    private int logoutTime;

    @Column(name = "level", comment = "等级")
    private int level;

    @Column(name = "online_time", comment = "本次在线时间")
    private int onlineTime;

    @Column(name = "event_id", comment = "登出事件")
    private int eventId;
}
