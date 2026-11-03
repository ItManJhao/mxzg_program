package com.ayjs.mxzg.common.persistence.sharding;

import com.ayjs.mxzg.common.persistence.annotation.Sharding;
import com.ayjs.mxzg.common.persistence.meta.MetaData;

import java.time.LocalDateTime;

/**
 * 分表策略
 */
public interface ShardingStrategy {
    /**
     * 策略
     *
     * @return
     */
    Sharding.Strategy strategy();

    /**
     * 根据key路由到对应的表 如果key为shardingId为null则获取分片的第一张表
     *
     * @param shardingId
     * @param metaData
     * @return
     */
    String routingTable(Object shardingId, MetaData metaData, LocalDateTime localDateTime);
}
