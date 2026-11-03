/**
 * 
 */
package com.ayjs.mxzg.largecross.module.towercross.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ayjs.mxzg.largecross.module.towercross.dao.TowerCrossRoleDao;
import com.ayjs.mxzg.largecross.module.towercross.domain.TowerCrossRole;

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
			towerCrossRoleDao.add(tower);
		}
		return tower;
	}
	
	public void updateTower(TowerCrossRole tower) {
		towerCrossRoleDao.update(tower);
	}
	
	public List<TowerCrossRole> getAll() {
		return towerCrossRoleDao.listAll();
	}
}
