/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.title.dao;

import org.springframework.stereotype.Repository;

import com.ayjs.mxzg.common.persistence.repository.CacheAllDelayedJDBCRepository;
import com.ayjs.mxzg.gameserver.module.title.domain.TitleSystem;

/**
 * @author YY
 *
 */
@Repository
public class TitleSystemDao extends CacheAllDelayedJDBCRepository<TitleSystem> {

}
