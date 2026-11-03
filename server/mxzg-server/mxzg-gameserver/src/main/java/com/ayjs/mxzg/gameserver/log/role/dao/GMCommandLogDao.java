package com.ayjs.mxzg.gameserver.log.role.dao;

import com.ayjs.mxzg.common.persistence.log.BaseLogRepository;
import com.ayjs.mxzg.gameserver.log.role.domain.GMCommandLog;
import org.springframework.stereotype.Repository;

/**
 * GM日志
 */
@Repository
public class GMCommandLogDao extends BaseLogRepository<GMCommandLog> {
}
