package com.ayjs.mxzg.gameserver.log.role.domain;

import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Index;
import com.ayjs.mxzg.common.persistence.annotation.ShardingId;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.template.log.AbstractOperateLog;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Table(name = "role_create_log", comment = "创号日志",
        indexes = {@Index(name = "idx_rid_time", columnList = {"rid", "create_time"}),
                @Index(name = "idx_time", columnList = "create_time")})
public class RoleCreateLog extends AbstractOperateLog {

    @Column(name = "open_id", length = 128, comment = "身份标识")
    private String openid;
    
    @ShardingId
    @Column(name = "create_time", comment = "创号时间", readOnly = true)
    private int loginTime;

    @Column(name = "ip", comment = "登录ip", length = 15)
    private String ip;

    @Column(name = "login_type", comment = "登录客户端类型0：IOS，1：安卓")
    private int loginType;

    @Column(name = "device_id", comment = "设备id", length = 128)
    private String deviceId;
}
