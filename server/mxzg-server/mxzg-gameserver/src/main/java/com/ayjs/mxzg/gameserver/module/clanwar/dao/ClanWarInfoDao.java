/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.clanwar.dao;

import org.springframework.stereotype.Repository;

import com.ayjs.mxzg.common.persistence.repository.CacheAllDelayedJDBCRepository;
import com.ayjs.mxzg.gameserver.module.clanwar.domain.ClanWarInfo;

/**
 * @author YY
 *
 */
@Repository
public class ClanWarInfoDao extends CacheAllDelayedJDBCRepository<ClanWarInfo> {

}
