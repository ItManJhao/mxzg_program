package com.ayjs.mxzg.cross.module.crossrole.dao;

import com.ayjs.mxzg.common.persistence.repository.CacheAllDelayedJDBCRepository;
import com.ayjs.mxzg.message.module.role.domain.CrossRole;
import org.springframework.stereotype.Repository;

@Repository
public class CrossRoleJDBCDao extends CacheAllDelayedJDBCRepository<CrossRole> {
}
