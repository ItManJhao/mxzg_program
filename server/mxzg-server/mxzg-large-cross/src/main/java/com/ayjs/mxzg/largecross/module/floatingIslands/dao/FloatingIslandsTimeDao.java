package com.ayjs.mxzg.largecross.module.floatingIslands.dao;

import com.ayjs.mxzg.common.persistence.repository.BaseRepository;
import com.ayjs.mxzg.message.module.floatingIslands.struct.FloatingIslandsTime;
import org.springframework.stereotype.Repository;

/**
 * @Author: CWJ
 * @Date: 2020/6/30
 **/
@Repository
public class FloatingIslandsTimeDao extends BaseRepository<FloatingIslandsTime> {

    private static final long UNIQUE_ID = 1l;

    public FloatingIslandsTime get() {
        FloatingIslandsTime floatingIslandsTime = get(UNIQUE_ID);
        if (floatingIslandsTime == null) {
            floatingIslandsTime = new FloatingIslandsTime();
            floatingIslandsTime.setStage(-1);
            floatingIslandsTime.setId(UNIQUE_ID);
            add(floatingIslandsTime);
        }
        return floatingIslandsTime;
    }
}
