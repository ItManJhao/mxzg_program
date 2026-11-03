/**
 * 
 */
package com.ayjs.mxzg.cross.module.clanwar.dao;

import org.springframework.stereotype.Repository;

import com.ayjs.mxzg.common.persistence.repository.CacheAllDelayedJDBCRepository;
import com.ayjs.mxzg.cross.module.clanwar.domain.ClanWarCrossInfo;

/**
 * @author YY
 *
 */
@Repository
public class ClanWarCrossInfoDao extends CacheAllDelayedJDBCRepository<ClanWarCrossInfo> {

}
