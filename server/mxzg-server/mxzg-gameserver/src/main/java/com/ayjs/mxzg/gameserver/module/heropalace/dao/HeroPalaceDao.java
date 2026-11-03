package com.ayjs.mxzg.gameserver.module.heropalace.dao;

import com.ayjs.mxzg.common.persistence.repository.CacheAllDelayedJDBCRepository;
import com.ayjs.mxzg.gameserver.module.heropalace.domain.HeroPalace;
import org.springframework.stereotype.Repository;

/**
 * @Author: CWJ
 * @Date: 2020/3/24
 **/
@Repository
public class HeroPalaceDao extends CacheAllDelayedJDBCRepository<HeroPalace> {

    public HeroPalace getByType(int type) {
        return get("type", type);
    }
}
