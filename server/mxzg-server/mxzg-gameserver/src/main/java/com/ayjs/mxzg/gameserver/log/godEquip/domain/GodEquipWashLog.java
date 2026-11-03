package com.ayjs.mxzg.gameserver.log.godEquip.domain;


import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Sharding;
import com.ayjs.mxzg.common.persistence.annotation.ShardingId;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.config.struct.GodAttr;
import com.ayjs.mxzg.template.log.AbstractOperateLog;
import lombok.Getter;
import lombok.Setter;

import java.util.ArrayList;
import java.util.List;


@Sharding(strategy = Sharding.Strategy.DATE, period = Sharding.Period.MONTHLY)
@Table(name = "god_equip_wash_log", comment = "神装洗炼日志")
@Setter
@Getter
public class GodEquipWashLog extends AbstractOperateLog {

    @Column(name = "god_equip_id", comment = "神装id")
    private long godEquipId;
    @Column(name = "old_ability", comment = "旧属性")
    private List<GodAttr> oldAbility = new ArrayList<>();
    @Column(name = "new_ability",comment = "新属性")
    private List<GodAttr> newAbility = new ArrayList<>();
    @ShardingId
    @Column(name = "time", comment = "操作的时间", readOnly = true)
    private int time;
}
