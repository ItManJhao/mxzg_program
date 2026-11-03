/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.towercross.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.gameserver.module.towercross.dao.TowerCrossRoleDao;
import com.ayjs.mxzg.gameserver.module.towercross.domain.TowerCrossRole;

/**
 * @author YY
 *
 */
@Service
public class TowerCrossRoleService {

	@Autowired
	private TowerCrossRoleDao towerCrossRoleDao;
	
	public TowerCrossRole getTower(long rid) {
		TowerCrossRole tower = towerCrossRoleDao.get(rid);
		if(tower == null) {
			tower = new TowerCrossRole();
			tower.setRid(rid);
			tower.setDailyTime(TimeDateUtil.getTomorrowZeroTimeInt());
			towerCrossRoleDao.add(tower);
		}
		if(TimeDateUtil.getCurrentTimeInt() >= tower.getDailyTime()) {
			tower.setDailyTime(TimeDateUtil.getTomorrowZeroTimeInt());
			tower.setFailNum(0);
			towerCrossRoleDao.update(tower);
		}
		return tower;
	}
	
	public void updateTower(TowerCrossRole tower) {
		towerCrossRoleDao.update(tower);
	}
}
