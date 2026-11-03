package com.ayjs.mxzg.gameserver.module.rank.dao;

import com.ayjs.mxzg.common.persistence.repository.CacheAllDelayedJDBCRepository;
import com.ayjs.mxzg.common.redis.AbstractRedisRepository;
import com.ayjs.mxzg.gameserver.module.rank.domain.RankWorship;
import com.ayjs.mxzg.gameserver.module.rank.domain.RankWorshipRedis;
import org.springframework.stereotype.Repository;

/**
 * @Author: CWJ
 * @Date: 2019/10/16
 **/
@Repository
public class RankWorshipRedisDao extends AbstractRedisRepository<Long, RankWorshipRedis> {

}
