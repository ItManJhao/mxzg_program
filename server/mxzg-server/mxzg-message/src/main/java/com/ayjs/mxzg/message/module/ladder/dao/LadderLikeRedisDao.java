package com.ayjs.mxzg.message.module.ladder.dao;

import com.ayjs.mxzg.common.redis.AbstractRedisRepository;
import com.ayjs.mxzg.message.module.ladder.domain.LadderLike;
import org.springframework.stereotype.Repository;

/**
 * 天梯点赞
 */
@Repository
public class LadderLikeRedisDao extends AbstractRedisRepository<String, LadderLike> {

}
