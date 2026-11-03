package com.ayjs.mxzg.gameserver.log.shop.domain;

import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Sharding;
import com.ayjs.mxzg.common.persistence.annotation.ShardingId;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.template.log.AbstractOperateLog;
import lombok.Getter;
import lombok.Setter;

@Sharding(strategy = Sharding.Strategy.DATE, period = Sharding.Period.MONTHLY)
@Table(name = "shop_log", comment = "商城日志")
@Setter
@Getter
public class ShopLog extends AbstractOperateLog {
    @Column(name = "shop_type", comment = "商店类型")
    private int shopType;
    @Column(name = "shop_idx", comment = "购买的下表")
    private int shopIdx;
    @Column(name = "buy_times", comment = "购买次数")
    private int buyTimes;
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
