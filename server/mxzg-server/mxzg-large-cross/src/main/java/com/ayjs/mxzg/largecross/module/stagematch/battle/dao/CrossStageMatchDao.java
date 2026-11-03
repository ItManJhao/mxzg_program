/**
 *
 */
package com.ayjs.mxzg.largecross.module.stagematch.battle.dao;

import com.ayjs.mxzg.common.persistence.repository.BaseRepository;
import com.ayjs.mxzg.largecross.module.stagematch.battle.domain.CrossStageMatch;
import org.springframework.stereotype.Repository;

/**
 * 段位赛
 */
@Repository
public class CrossStageMatchDao extends BaseRepository<CrossStageMatch> {

    /** 唯一主键id */
    private final static int UNIQUE_ID = 1;

    /**
     * 获取跨服集群实体
     * @returnCrossStageMatchDao
     */
    public CrossStageMatch get() {
        CrossStageMatch crossServerGroup = get(UNIQUE_ID);
        if (crossServerGroup == null) {
            crossServerGroup = new CrossStageMatch();
            crossServerGroup.setId(UNIQUE_ID);
            add(crossServerGroup);
        }
        return crossServerGroup;
    }

}
