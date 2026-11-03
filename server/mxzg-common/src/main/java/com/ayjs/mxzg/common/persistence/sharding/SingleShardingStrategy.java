package com.ayjs.mxzg.common.persistence.sharding;

import com.ayjs.mxzg.common.persistence.annotation.Sharding;
import com.ayjs.mxzg.common.persistence.meta.MetaData;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;

/**
 * 单表策略
 */
@Component
public class SingleShardingStrategy implements ShardingStrategy {
    @Override
    public Sharding.Strategy strategy() {
        return Sharding.Strategy.SINGLE;
    }

    @Override
    public String routingTable(Object shardingId, MetaData metaData, LocalDateTime localDateTime) {
        return metaData.getTableMeta().getName();
    }
}
