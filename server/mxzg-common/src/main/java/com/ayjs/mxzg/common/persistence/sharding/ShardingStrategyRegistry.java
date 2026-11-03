package com.ayjs.mxzg.common.persistence.sharding;

import com.ayjs.mxzg.common.base.IRegister;
import com.ayjs.mxzg.common.persistence.annotation.Sharding;
import com.google.common.base.Preconditions;
import org.springframework.stereotype.Component;

import java.util.HashMap;
import java.util.Map;
import java.util.Objects;

/**
 * 分表策略注册器
 */
@Component
public class ShardingStrategyRegistry implements IRegister<ShardingStrategy> {

    private final Map<Sharding.Strategy, ShardingStrategy> holder = new HashMap<>();

    @Override
    public void registerBean(ShardingStrategy bean) {
        holder.put(Objects.requireNonNull(bean.strategy()), bean);
    }

    public ShardingStrategy getOrThrow(Sharding.Strategy key) {
        ShardingStrategy strategy = holder.get(key);
        Preconditions.checkNotNull(strategy, "%s unregister", key);
        return strategy;
    }
}
