/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.godequip.dao;

import org.springframework.stereotype.Repository;

import com.ayjs.mxzg.common.persistence.repository.CacheAllDelayedJDBCRepository;
import com.ayjs.mxzg.gameserver.module.godequip.domain.GodEquipSysInfo;

/**
 * @author YY
 *
 */
@Repository
public class GodEquipSysInfoDao extends CacheAllDelayedJDBCRepository<GodEquipSysInfo> {

}
