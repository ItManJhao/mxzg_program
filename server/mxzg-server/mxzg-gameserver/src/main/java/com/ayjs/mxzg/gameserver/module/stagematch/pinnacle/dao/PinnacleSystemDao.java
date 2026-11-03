/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.stagematch.pinnacle.dao;

import com.ayjs.mxzg.common.persistence.repository.CacheAllDelayedJDBCRepository;
import com.ayjs.mxzg.gameserver.module.stagematch.pinnacle.domain.PinnacleSystem;
import org.springframework.stereotype.Repository;

/**
 * @author YY
 *
 */
@Repository
public class PinnacleSystemDao extends CacheAllDelayedJDBCRepository<PinnacleSystem> {

}
