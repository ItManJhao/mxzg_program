package com.ayjs.mxzg.template.repository;


import com.ayjs.mxzg.common.base.Initialization;
import com.ayjs.mxzg.common.base.SpringProxy;
import com.ayjs.mxzg.common.lifecycle.Lifecycle;
import com.ayjs.mxzg.common.lifecycle.LifecycleInfo;
import com.ayjs.mxzg.common.lifecycle.Ordinal;
import com.ayjs.mxzg.common.lifecycle.Priority;
import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.DatabaseHelper;
import com.ayjs.mxzg.common.persistence.TableRegistry;
import com.ayjs.mxzg.common.persistence.annotation.CRepository;
import com.ayjs.mxzg.common.persistence.generator.IdGeneratorRegistry;
import com.ayjs.mxzg.common.persistence.meta.MetaData;
import com.ayjs.mxzg.common.persistence.meta.MetaDataRegistry;
import com.ayjs.mxzg.common.persistence.persister.JdbcPersisterFactory;
import com.ayjs.mxzg.common.persistence.persister.Persister;
import com.ayjs.mxzg.common.persistence.persister.PersisterRegistry;
import com.ayjs.mxzg.common.persistence.repository.DataBaseAccessor;
import com.ayjs.mxzg.common.persistence.repository.DataBaseAccessorManager;
import com.ayjs.mxzg.common.persistence.repository.DelayedJDBCRepository;
import com.ayjs.mxzg.common.persistence.repository.ICacheAllRepository;
import com.ayjs.mxzg.common.persistence.repository.IRepository;
import com.ayjs.mxzg.common.persistence.sharding.ShardingSqlAssembly;
import com.ayjs.mxzg.common.util.TypeUtil;
import com.google.common.base.Preconditions;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Objects;
import java.util.Set;

@Slf4j
@Component
@Configuration
public class RepositoryLifecycle<K, T extends AbstractEntity> implements Lifecycle {

    @Autowired
    private MetaDataRegistry metaDataRegistry;
    @Autowired
    private TableRegistry tableRegistry;
    @Autowired
    private ShardingSqlAssembly<K, T> sqlAssembly;
    @Autowired
    private PersisterRegistry<K, T> persisterRegistry;
    @Autowired
    private IdGeneratorRegistry idGeneratorRegistry;
    @Value("${server.id:1}")
    private int serverId;
    // 关闭服务的时候用到
    @Autowired
    private Set<DelayedJDBCRepository> delayedJDBCRepositorySet;

    @Override
    public LifecycleInfo getInfo() {
        return LifecycleInfo.valueOf(Priority.SYSTEM, Ordinal._4, "REPOSITORY");
    }

    @Override
    public void start() throws Exception {
        // 加载仓储
        SpringProxy.getBeansOfType(IRepository.class).forEach(this::loadRepository);
        // 加载全表数据到缓存
        SpringProxy.getBeansOfType(ICacheAllRepository.class).forEach(ICacheAllRepository::loadAllDataToCache);

    }

    @Override
    public void stop() throws Exception {
        if (Objects.nonNull(delayedJDBCRepositorySet)) {
            delayedJDBCRepositorySet.forEach(repository -> {
                try {
                    repository.shutdown();
                } catch (Exception e) {
                    e.printStackTrace();
                }
            });
        }
        DataBaseAccessorManager.getInstance().shutdown();
    }

    @SuppressWarnings("rawtypes")
    private void loadRepository(IRepository bean) {
        CRepository repository = TypeUtil.resolveAnnotation(CRepository.class, bean.getClass());
        if (repository == null) {
            return;
        }
        Class<T> entityType = resolveEntityType(bean);
        MetaData metaData = MetaData.build(entityType);
        metaDataRegistry.register(entityType, metaData);

        DataBaseAccessor db = DataBaseAccessorManager.getInstance().get(repository.source());
        Preconditions.checkNotNull(db, "cannot find db, source: %s", repository.source());

        List<String> tableNames = DatabaseHelper.getTableNames(db, metaData.getTableMeta().getName());
        tableNames.forEach(tableName -> tableRegistry.addTable(entityType, tableName));

        String currTableName = sqlAssembly.routingTable(null, metaData);
        if (tableNames.isEmpty() || !tableNames.contains(currTableName)) {
            tableRegistry.checkOrCreate(currTableName, db, metaData);
        } else {
            DatabaseHelper.updateTableStructure(db, metaData.getTableMeta(), tableNames);
        }

        Persister<K, T> persister = JdbcPersisterFactory.create(entityType, db, metaData);
        persisterRegistry.register(entityType, persister);

        idGeneratorRegistry.initIdGenerator(serverId, db, metaData, currTableName);

        if (bean instanceof Initialization) {
            ((Initialization) bean).initialize();
        }
    }

    @SuppressWarnings({"rawtypes", "unchecked"})
    private Class<T> resolveEntityType(IRepository bean) {
        return (Class<T>) TypeUtil.resolveClassArguments(bean.getClass(), IRepository.class)[0];
    }
}