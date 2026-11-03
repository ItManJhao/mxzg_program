/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.hero.dao;

import org.springframework.stereotype.Repository;

import com.ayjs.mxzg.common.persistence.repository.CacheAllDelayedJDBCRepository;
import com.ayjs.mxzg.gameserver.module.hero.domain.HeroScore;

/**
 * @author YY
 *
 */
@Repository
public class HeroScoreDao extends CacheAllDelayedJDBCRepository<HeroScore> {

}
