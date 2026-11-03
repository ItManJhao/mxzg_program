package com.ayjs.mxzg.gameserver.module.heroShare.dao;

import org.springframework.stereotype.Repository;

import com.ayjs.mxzg.common.redis.AbstractRedisRepository;
import com.ayjs.mxzg.gameserver.module.heroShare.domain.HeroShareInfo;

/**
 * @author hyx
 */
@Repository
public class HeroShareInfoDao extends AbstractRedisRepository<String,HeroShareInfo> {
}
