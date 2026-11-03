/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.champion.dao;

import org.springframework.stereotype.Repository;

import com.ayjs.mxzg.common.persistence.repository.CacheAllDelayedJDBCRepository;
import com.ayjs.mxzg.gameserver.module.champion.domain.ChampionSystem;

/**
 * @author YY
 *
 */
@Repository
public class ChampionSystemDao extends CacheAllDelayedJDBCRepository<ChampionSystem> {

}
