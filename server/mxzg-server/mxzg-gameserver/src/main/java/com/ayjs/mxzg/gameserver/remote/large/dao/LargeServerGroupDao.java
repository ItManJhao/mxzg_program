package com.ayjs.mxzg.gameserver.remote.large.dao;

import com.ayjs.mxzg.common.persistence.repository.BaseRepository;
import com.ayjs.mxzg.gameserver.remote.large.domain.LargeServerGroup;
import org.springframework.stereotype.Repository;

/**
 * @Author: CWJ
 * @Date: 2020/6/20
 **/
@Repository
public class LargeServerGroupDao extends BaseRepository<LargeServerGroup> {


    /**
     * 唯一主键id
     */
    private final int UNIQUE_ID = 1;

    /**
     * 获取跨服分组实体
     *
     * @return
     */
    public LargeServerGroup get() {
        LargeServerGroup crossGroup = get(UNIQUE_ID);
        if (crossGroup == null) {
            crossGroup = new LargeServerGroup();
            crossGroup.setId(UNIQUE_ID);
            add(crossGroup);
        }
        return crossGroup;
    }
}
