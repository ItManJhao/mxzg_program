package com.ayjs.mxzg.common.persistence.log;

import com.ayjs.mxzg.common.base.IRegister;
import com.ayjs.mxzg.common.util.Asserts;
import com.google.common.collect.ImmutableMap;
import org.springframework.stereotype.Component;

import java.util.HashMap;
import java.util.Map;
import java.util.Objects;

/**
 * 日志仓储
 */
@Component
public class LogRepositoryRegistry implements IRegister<BaseLogRepository<?>> {

    private final Map<Class<?>, BaseLogRepository<?>> repositories = new HashMap<>();

    @Override
    public void registerBean(BaseLogRepository<?> bean) {
        Asserts.isNull(repositories.putIfAbsent(Objects.requireNonNull(bean.getEntityType()), bean),
                String.format("{%s} duplicated", bean.getEntityType()));
    }

    @SuppressWarnings("rawtypes")
    public BaseLogRepository getRepository(Class<?> clazz) {
        return repositories.get(clazz);
    }

    public Map<Class<?>, BaseLogRepository<?>> getRepositories() {
        return ImmutableMap.copyOf(repositories);
    }
}
