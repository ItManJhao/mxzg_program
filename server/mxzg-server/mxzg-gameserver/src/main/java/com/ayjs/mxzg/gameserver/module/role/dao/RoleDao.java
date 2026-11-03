/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.role.dao;

import org.springframework.stereotype.Repository;

import com.ayjs.mxzg.common.persistence.repository.CacheAllDelayedJDBCRepository;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;

/**
 * @author YY
 *
 */
@Repository
public class RoleDao extends CacheAllDelayedJDBCRepository<Role> {

}
