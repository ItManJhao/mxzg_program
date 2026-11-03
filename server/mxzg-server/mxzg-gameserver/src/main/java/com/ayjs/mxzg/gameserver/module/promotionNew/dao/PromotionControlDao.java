/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.promotionNew.dao;

import org.springframework.stereotype.Repository;

import com.ayjs.mxzg.common.persistence.repository.CacheAllDelayedJDBCRepository;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.PromotionControl;

/**
 * @author YY
 *
 */
@Repository
public class PromotionControlDao extends CacheAllDelayedJDBCRepository<PromotionControl> {

}
