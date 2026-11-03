package com.ayjs.mxzg.cross.module.spacetimeAdventure.dao;

import com.ayjs.mxzg.common.persistence.repository.CacheAllDelayedJDBCRepository;
import com.ayjs.mxzg.cross.module.spacetimeAdventure.domain.CrossFleetInfo;
import org.springframework.stereotype.Repository;

@Repository
public class CrossFleetInfoDao extends CacheAllDelayedJDBCRepository<CrossFleetInfo> {
}
