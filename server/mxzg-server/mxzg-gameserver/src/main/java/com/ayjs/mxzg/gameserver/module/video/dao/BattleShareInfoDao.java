/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.video.dao;

import org.springframework.stereotype.Repository;

import com.ayjs.mxzg.common.redis.AbstractRedisRepository;
import com.ayjs.mxzg.gameserver.module.video.domain.BattleShareInfo;

/**
 * @author YY
 *
 */
@Repository
public class BattleShareInfoDao extends AbstractRedisRepository<String, BattleShareInfo> {
	
}
