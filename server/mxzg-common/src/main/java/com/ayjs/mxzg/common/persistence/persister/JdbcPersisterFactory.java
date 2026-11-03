package com.ayjs.mxzg.common.persistence.persister;

import com.ayjs.mxzg.common.base.SpringProxy;
import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.meta.MetaData;
import com.ayjs.mxzg.common.persistence.repository.DataBaseAccessor;

/**
 * 数据操作工厂
 */
public class JdbcPersisterFactory {

    public static <K, T extends AbstractEntity> Persister<K, T> create(Class<T> entityType, DataBaseAccessor db, MetaData metaData) {
        Persister<K, T> persister = new JdbcPersister(entityType, db, metaData, db.getSlowLog());
        SpringProxy.injectionBean(persister);
        return persister;
    }
}
