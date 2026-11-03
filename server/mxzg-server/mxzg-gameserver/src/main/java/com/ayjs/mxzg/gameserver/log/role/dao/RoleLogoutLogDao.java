package com.ayjs.mxzg.gameserver.log.role.dao;

import org.springframework.stereotype.Repository;

import com.ayjs.mxzg.common.persistence.log.BaseLogRepository;
import com.ayjs.mxzg.gameserver.log.role.domain.RoleLogoutLog;

/**
 * 角色登出
 */
@Repository
public class RoleLogoutLogDao extends BaseLogRepository<RoleLogoutLog> {
}
