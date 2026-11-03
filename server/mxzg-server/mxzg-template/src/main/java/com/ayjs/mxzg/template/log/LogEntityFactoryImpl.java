package com.ayjs.mxzg.template.log;

import com.ayjs.mxzg.common.persistence.log.AbstractLog;
import com.ayjs.mxzg.common.persistence.log.BaseLogRepository;
import com.ayjs.mxzg.common.persistence.log.LogRepositoryRegistry;
import com.ayjs.mxzg.common.util.Asserts;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

/**
 * 日志ENTITY工厂实现
 */
@Component
public class LogEntityFactoryImpl implements LogEntityFactory {

    @Autowired
    private LogRepositoryRegistry logRepositoryRegistry;

    @SuppressWarnings({"rawtypes", "unchecked"})
    @Override
    public <T extends AbstractLog> T create(Class<T> clazz) {
        BaseLogRepository repository = logRepositoryRegistry.getRepository(clazz);
        Asserts.notNull(repository, () -> String.format("{%s} not registered", clazz));
        return (T) repository.create();
    }
}
