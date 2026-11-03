package com.ayjs.mxzg.gameserver.log.role.domain;

import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Sharding;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.template.log.AbstractOperateLog;
import lombok.Getter;
import lombok.Setter;

import java.util.Map;


@Getter
@Setter
@Sharding(strategy = Sharding.Strategy.SINGLE)
@Table(name = "role_statistic_daily_log", comment = "个人资源日志")
public class RoleStatisticDailyLog extends AbstractOperateLog {

    @Column(name = "items", comment = "道具")
    private Map<Integer, Long> items;

    @Column(name = "heroes", comment = "英雄")
    private Map<Integer, Long> heroes;

}
