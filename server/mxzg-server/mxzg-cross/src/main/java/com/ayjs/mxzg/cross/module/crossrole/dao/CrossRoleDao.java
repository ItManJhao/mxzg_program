package com.ayjs.mxzg.cross.module.crossrole.dao;

import com.ayjs.mxzg.cross.infrastructure.persistence.AbstractJDBCRedisRepository;
import com.ayjs.mxzg.message.module.role.dao.CrossRoleRedisDao;
import com.ayjs.mxzg.message.module.role.domain.CrossRole;
import org.springframework.stereotype.Repository;

@Repository
public class CrossRoleDao extends AbstractJDBCRedisRepository<Long, CrossRole> {

    public CrossRoleDao(CrossRoleJDBCDao jdbcRepository, CrossRoleRedisDao redisRepository) {
        super(jdbcRepository, redisRepository);
    }


}
