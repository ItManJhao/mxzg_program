/**
 *
 */
package com.ayjs.mxzg.center.module.dao;

import com.ayjs.mxzg.center.module.domain.CrossCluster;
import com.ayjs.mxzg.common.persistence.repository.BaseRepository;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Repository;

/**
 * 跨服集群Dao
 */
@Slf4j
@Repository
public class CrossClusterDao extends BaseRepository<CrossCluster> {

    /** 唯一主键id */
    private final int UNIQUE_ID = 1;

    /**
     * 获取跨服集群实体
     * @return
     */
    public CrossCluster get() {
        CrossCluster cluster = get(UNIQUE_ID);
        if (cluster == null) {
            cluster = new CrossCluster();
            cluster.setId(UNIQUE_ID);
            add(cluster);
        }
        return cluster;
    }

}
