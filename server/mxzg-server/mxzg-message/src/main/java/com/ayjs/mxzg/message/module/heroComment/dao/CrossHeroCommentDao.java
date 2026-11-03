package com.ayjs.mxzg.message.module.heroComment.dao;

import com.ayjs.mxzg.common.redis.AbstractRedisRepository;
import com.ayjs.mxzg.message.module.heroComment.domain.CrossHeroComment;
import org.springframework.stereotype.Repository;

/**
 * @Author: CWJ
 * @Date: 2020/6/11
 **/
@Repository
public class CrossHeroCommentDao extends AbstractRedisRepository<Integer, CrossHeroComment> {

}
