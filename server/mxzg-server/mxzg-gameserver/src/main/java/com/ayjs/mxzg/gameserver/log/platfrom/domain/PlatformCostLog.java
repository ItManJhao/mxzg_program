package com.ayjs.mxzg.gameserver.log.platfrom.domain;

import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.LongIdGenerate;
import com.ayjs.mxzg.common.persistence.annotation.Sharding;
import com.ayjs.mxzg.common.persistence.annotation.ShardingId;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.common.persistence.log.AbstractLog;
import lombok.Getter;
import lombok.Setter;

import java.util.HashMap;
import java.util.Map;

@Sharding(strategy = Sharding.Strategy.DATE, period = Sharding.Period.MONTHLY)
@Table(name = "platform_cost_log", comment = "平台扣除道具日志")
@Setter
@Getter
public class PlatformCostLog extends AbstractLog {

    @LongIdGenerate
    @Column(name = "id", comment = "标识")
    @Id
    private long id;
    @Column(name = "rid", comment = "扣除角色")
    private long rid;
    @Column(name = "cost_item", comment = "扣除道具")
    private Map<Integer, Long> costItem = new HashMap<>();
    @Column(name = "cost_recharge", comment = "扣除充值额,1总值，2周值，3，日值")
    private Map<Integer, Long> costRecharge = new HashMap<>();
    @ShardingId
    @Column(name = "time", comment = "日志时间", readOnly = true)
    private int time;

    @Override
    public Long getId() {
        return id;
    }

    @Override
    public void setId(Long id) {
        this.id = id;
    }
}