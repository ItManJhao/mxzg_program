/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.pvp.dao;

import org.springframework.stereotype.Repository;

import com.ayjs.mxzg.common.persistence.repository.CacheAllDelayedJDBCRepository;
import com.ayjs.mxzg.gameserver.module.pvp.domain.PvpSysInfo;

/**
 * @author YY
 *
 */
@Repository
public class PvpSysInfoDao extends CacheAllDelayedJDBCRepository<PvpSysInfo> {

}
