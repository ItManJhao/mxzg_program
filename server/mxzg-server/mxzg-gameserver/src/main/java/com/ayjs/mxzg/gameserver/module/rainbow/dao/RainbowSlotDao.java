/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.rainbow.dao;

import org.springframework.stereotype.Repository;

import com.ayjs.mxzg.common.persistence.repository.CacheAllDelayedJDBCRepository;
import com.ayjs.mxzg.gameserver.module.rainbow.domain.RainbowSlot;

/**
 * @author YY
 *
 */
@Repository
public class RainbowSlotDao extends CacheAllDelayedJDBCRepository<RainbowSlot> {

}
