package com.ayjs.mxzg.largecross.servergroup.dao;

import com.ayjs.mxzg.common.persistence.repository.BaseRepository;
import com.ayjs.mxzg.largecross.servergroup.domain.CrossServerGroup;
import org.springframework.stereotype.Repository;

/**
 * @Author: CWJ
 * @Date: 2020/6/18
 **/
@Repository
public class CrossServerGroupDao extends BaseRepository<CrossServerGroup> {

    /**
     * 唯一主键id
     */
    private final int UNIQUE_ID = 1;

    /**
     * 获取跨服集群实体
     *
     * @return
     */
    public CrossServerGroup get() {
        CrossServerGroup cluster = get(UNIQUE_ID);
        if (cluster == null) {
            cluster = new CrossServerGroup();
            cluster.setId(UNIQUE_ID);
            add(cluster);
        }
        return cluster;
    }
}
