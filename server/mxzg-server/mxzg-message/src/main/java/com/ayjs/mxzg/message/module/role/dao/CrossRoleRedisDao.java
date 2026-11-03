package com.ayjs.mxzg.message.module.role.dao;

import com.ayjs.mxzg.common.redis.AbstractRedisRepository;
import com.ayjs.mxzg.message.module.role.domain.CrossRole;
import org.springframework.stereotype.Repository;

@Repository
public class CrossRoleRedisDao extends AbstractRedisRepository<Long, CrossRole> {

}
