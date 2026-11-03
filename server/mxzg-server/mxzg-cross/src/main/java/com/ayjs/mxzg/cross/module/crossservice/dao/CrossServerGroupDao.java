/**
 *
 */
package com.ayjs.mxzg.cross.module.crossservice.dao;

import com.ayjs.mxzg.common.persistence.repository.BaseRepository;
import com.ayjs.mxzg.cross.module.crossservice.domain.CrossServerGroup;
import org.springframework.stereotype.Repository;

/**
 * 跨服分组Dao
 */
@Repository
public class CrossServerGroupDao extends BaseRepository<CrossServerGroup> {

    /** 唯一主键id */
    private final static int UNIQUE_ID = 1;

    /**
     * 获取跨服集群实体
     * @return
     */
    public CrossServerGroup get() {
        CrossServerGroup crossServerGroup = get(UNIQUE_ID);
        if (crossServerGroup == null) {
            crossServerGroup = new CrossServerGroup();
            crossServerGroup.setId(UNIQUE_ID);
            add(crossServerGroup);
        }
        return crossServerGroup;
    }

}
