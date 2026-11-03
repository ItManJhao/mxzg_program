package com.ayjs.mxzg.gameserver.log.click.domain;

import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Sharding;
import com.ayjs.mxzg.common.persistence.annotation.ShardingId;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.template.log.AbstractOperateLog;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

/**
 * @Author: CWJ
 * @Date: 2020/3/11
 **/
@Getter
@Setter
@Sharding(strategy = Sharding.Strategy.DATE, period = Sharding.Period.MONTHLY)
@Table(name = "role_click_log", comment = "点击日志")
public class ClickLog extends AbstractOperateLog {

    @Column(name = "click_code", comment = "点击码")
    private int clickCode;

    @ShardingId
    @Column(name = "click_time", comment = "操作的时间", readOnly = true)
    private LocalDateTime clickTime;

}
