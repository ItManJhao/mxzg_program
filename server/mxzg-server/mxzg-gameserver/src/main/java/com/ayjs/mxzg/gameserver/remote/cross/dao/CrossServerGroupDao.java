/**
 *
 */
package com.ayjs.mxzg.gameserver.remote.cross.dao;

import com.ayjs.mxzg.common.persistence.repository.CacheAllDelayedJDBCRepository;
import com.ayjs.mxzg.gameserver.remote.cross.domain.CrossServerGroup;
import org.springframework.stereotype.Repository;

/**
 * 跨服分组Dao
 */
@Repository
public class CrossServerGroupDao extends CacheAllDelayedJDBCRepository<CrossServerGroup> {

    /** 唯一主键id */
    private final int UNIQUE_ID = 1;

    /**
     * 获取跨服分组实体
     * @return
     */
    public CrossServerGroup get() {
        CrossServerGroup cluster = get(UNIQUE_ID);
        if (cluster == null) {
            cluster = new CrossServerGroup();
            cluster.setId(UNIQUE_ID);
            cluster.setIp("");
            add(cluster);
        }
        return cluster;
    }

}
