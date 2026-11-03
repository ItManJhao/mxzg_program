package com.ayjs.mxzg.common.persistence.sharding;

import com.ayjs.mxzg.common.persistence.annotation.Sharding;
import lombok.Getter;
import lombok.ToString;

@Getter
@ToString
public class ShardingMeta {

    /**
     * 分片策略
     */
    private final Sharding.Strategy strategy;

    /**
     * 分片周期  strategy = DATE 时该值有意义
     */
    private final Sharding.Period period;

    /**
     * 单表数据量大小
     */
    private final int size;

    private ShardingMeta(Sharding.Strategy strategy, Sharding.Period period, int size) {
        this.strategy = strategy;
        this.period = period;
        this.size = size;
    }

    public static ShardingMeta of(Sharding sharding) {
        return new ShardingMeta(sharding.strategy(), sharding.period(), sharding.size());
    }
}
