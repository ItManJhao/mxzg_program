package com.ayjs.mxzg.common.persistence.sharding;

import com.ayjs.mxzg.common.convert.ConvertUtils;
import com.ayjs.mxzg.common.persistence.SqlBuilder;
import com.ayjs.mxzg.common.persistence.annotation.Sharding;
import com.ayjs.mxzg.common.persistence.meta.MetaData;
import com.ayjs.mxzg.common.util.time.LocalDateTimeUtil;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;
import java.util.Objects;

@Component
public class DateShardingStrategy implements ShardingStrategy {

    @Override
    public Sharding.Strategy strategy() {
        return Sharding.Strategy.DATE;
    }

    @Override
    public String routingTable(Object shardingId, MetaData metaData, LocalDateTime localDateTime) {
        LocalDateTime dateTime = null;
        if (Objects.nonNull(shardingId)) {
            Class<?> type = metaData.getShardingId().getField().getType();
            if (type == Long.TYPE || type == Long.class) {
                dateTime = LocalDateTimeUtil.ofEpochMilli(ConvertUtils.toLong(shardingId));
            } else if (type == Integer.TYPE || type == Integer.class) {
                dateTime = LocalDateTimeUtil.ofEpochSecond(ConvertUtils.toInt(shardingId));
            } else if (type == LocalDateTime.class) {
                dateTime = (LocalDateTime) shardingId;
            }
        }
        if (Objects.isNull(dateTime)) {
            dateTime = localDateTime;
        }
        String shardingName = metaData.getShardingMeta().getPeriod().getPeriodName(dateTime);
        return SqlBuilder.buildShardingName(metaData.getTableMeta().getName(), shardingName);
    }
}
