package com.ayjs.mxzg.gameserver.log.role.domain;

import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Sharding;
import com.ayjs.mxzg.common.persistence.annotation.ShardingId;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.template.log.AbstractOperateLog;
import lombok.Getter;
import lombok.Setter;


@Getter
@Setter
@Sharding(strategy = Sharding.Strategy.DATE, period = Sharding.Period.MONTHLY)
@Table(name = "role_Rename_nick_log", comment = "改名日志")
public class RoleRenameNickLog extends AbstractOperateLog {

    @Column(name = "old_nick",comment = "原昵称")
    private String oldNick;

    @Column(name = "new_nick",comment = "新昵称")
    private String newNick;

    @ShardingId
    @Column(name = "rename_time",comment = "修改时间", readOnly = true)
    private int renameTime;

}
