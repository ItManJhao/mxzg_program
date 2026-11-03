package com.ayjs.mxzg.common.redis;

import com.ayjs.mxzg.common.base.IRegister;
import com.ayjs.mxzg.common.base.Initialization;
import org.springframework.stereotype.Component;

/**
 * 仓储初始化
 */
@SuppressWarnings("rawtypes")
@Component
public class RedisRepositoryInitializer implements IRegister<RedisRepository> {

    @Override
    public void registerBean(RedisRepository bean) {
        if (bean instanceof Initialization) {
            ((Initialization) bean).initialize();
        }
    }
}