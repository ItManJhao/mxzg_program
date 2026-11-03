package com.ayjs.mxzg.gameserver.module.floatingIslands.dao;

import com.ayjs.mxzg.common.persistence.repository.BaseRepository;
import com.ayjs.mxzg.message.module.floatingIslands.struct.FloatingIslands;
import org.springframework.stereotype.Repository;

/**
 * @Author: CWJ
 * @Date: 2020/7/1
 **/
@Repository
public class FloatingIslandsDao extends BaseRepository<FloatingIslands> {

    private static final int UNIQUE_ID = 1;

    public FloatingIslands get() {
        FloatingIslands floatingIslands = get(UNIQUE_ID);
        if (floatingIslands == null) {
            floatingIslands = new FloatingIslands();
            floatingIslands.setId(UNIQUE_ID);
            add(floatingIslands);
        }
        return floatingIslands;
    }
}
