package com.ayjs.mxzg.gameserver.log.role.domain;

import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.template.log.AbstractOperateLog;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;
import java.util.List;

@Getter
@Setter
@Table(name = "gm_command_log", comment = "GM日志")
public class GMCommandLog extends AbstractOperateLog {
    @Column(name = "command", comment = "命令")
    private String command;
    @Column(name = "params", comment = "参数")
    private List<String> params;
    @Column(name = "dateTime", comment = "时间")
    private LocalDateTime dateTime;
}
