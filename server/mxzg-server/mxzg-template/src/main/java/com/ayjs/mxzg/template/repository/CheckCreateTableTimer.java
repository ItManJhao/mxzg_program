package com.ayjs.mxzg.template.repository;

import com.ayjs.mxzg.common.base.SpringProxy;
import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.TableRegistry;
import com.ayjs.mxzg.common.persistence.annotation.CRepository;
import com.ayjs.mxzg.common.persistence.annotation.Sharding;
import com.ayjs.mxzg.common.persistence.log.BaseLogRepository;
import com.ayjs.mxzg.common.persistence.meta.MetaData;
import com.ayjs.mxzg.common.persistence.repository.DataBaseAccessor;
import com.ayjs.mxzg.common.persistence.repository.DataBaseAccessorManager;
import com.ayjs.mxzg.common.persistence.repository.IRepository;
import com.ayjs.mxzg.common.persistence.sharding.ShardingSqlAssembly;
import com.ayjs.mxzg.common.util.TypeUtil;
import com.ayjs.mxzg.template.scheduler.service.AbstractCronTask;
import com.google.common.base.Preconditions;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;

/**
 * 凌晨4点多提前检查生成按日期分的表（提前两天检查）
 *
 * @param <K>
 * @param <T>
 */
@Component
@Slf4j
public class CheckCreateTableTimer<K, T extends AbstractEntity> extends AbstractCronTask {

    @Autowired
    private TableRegistry tableRegistry;
    @Autowired
    private ShardingSqlAssembly<K, T> sqlAssembly;

    @Override
    public Object identity() {
        return "CheckCreateTableTimer";
    }

    @Override
    public String expression() {
        return "0 22 4 * * ?";
    }

    @Override
    public void run() {
        SpringProxy.getBeansOfType(BaseLogRepository.class).forEach(this::checkCreateTable);
    }

    private void checkCreateTable(BaseLogRepository bean) {
        try {

            CRepository repository = TypeUtil.resolveAnnotation(CRepository.class, bean.getClass());
            if (repository == null) {
                return;
            }
            Class<T> entityType = resolveEntityType(bean);
            MetaData metaData = MetaData.build(entityType);

            DataBaseAccessor db = DataBaseAccessorManager.getInstance().get(repository.source());
            Preconditions.checkNotNull(db, "cannot find db, source: %s", repository.source());
            LocalDateTime nextLocalDateTime = LocalDateTime.now().plusDays(2);
            if (Sharding.Strategy.DATE == metaData.getShardingMeta().getStrategy()) {
                String nextTableName = sqlAssembly.nextDateTableName(metaData, nextLocalDateTime);
                tableRegistry.checkOrCreate(nextTableName, db, metaData);
                log.debug("checkOrCreate repository:{} table:{}", repository.getClass().getSimpleName(), nextTableName);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private Class<T> resolveEntityType(IRepository bean) {
        return (Class<T>) TypeUtil.resolveClassArguments(bean.getClass(), BaseLogRepository.class)[0];
    }
}
