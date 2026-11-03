package com.ayjs.mxzg.gameserver.log.dungeon.domain;

import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Sharding;
import com.ayjs.mxzg.common.persistence.annotation.ShardingId;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.template.log.AbstractOperateLog;
import lombok.Getter;
import lombok.Setter;

@Sharding(strategy = Sharding.Strategy.DATE, period = Sharding.Period.MONTHLY)
@Table(name = "dungeon_shop_log", comment = "庇护所商城日志")
@Setter
@Getter
public class DungeonShopLog extends AbstractOperateLog {

    @Column(name = "shop_idx", comment = "商品配置表idx")
    private int shopIdx;
    @Column(name = "cost_item_type", comment = "消耗道具类型")
    private int costItemType;
    @Column(name = "cost_item_num", comment = "消耗道具数量")
    private long costItemNum;
    @Column(name = "reward_item_type", comment = "获得道具类型")
    private int rewardItemType;
    @Column(name = "reward_item_num", comment = "获得道具数量")
    private long rewardItemNum;
    @ShardingId
    @Column(name = "dateTime", comment = "时间", readOnly = true)
    private int dateTime;

}
