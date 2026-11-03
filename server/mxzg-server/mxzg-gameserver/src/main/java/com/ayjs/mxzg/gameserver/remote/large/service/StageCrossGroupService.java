package com.ayjs.mxzg.gameserver.remote.large.service;

import com.ayjs.mxzg.gameserver.remote.large.dao.LargeServerGroupDao;
import com.ayjs.mxzg.gameserver.remote.large.domain.LargeServerGroup;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * @Author: CWJ
 * @Date: 2020/6/20
 **/
@Service
public class StageCrossGroupService {

    @Autowired
    private LargeServerGroupDao largeServerGroupDao;

    public LargeServerGroup get() {
        return largeServerGroupDao.get();
    }

    public void update(LargeServerGroup entity) {
        largeServerGroupDao.update(entity);
    }
}
