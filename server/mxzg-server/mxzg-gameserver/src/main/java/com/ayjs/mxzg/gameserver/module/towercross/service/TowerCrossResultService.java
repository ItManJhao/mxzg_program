/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.towercross.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ayjs.mxzg.gameserver.module.towercross.dao.TowerCrossResultDao;
import com.ayjs.mxzg.gameserver.module.towercross.domain.TowerCrossResult;

/**
 * @author YY
 *
 */
@Service
public class TowerCrossResultService {

	@Autowired
	private TowerCrossResultDao towerCrossResultDao;
	
	
	public TowerCrossResult getResult(int round) {
		TowerCrossResult result = towerCrossResultDao.get("round", round);
		if(result == null) {
			result = new TowerCrossResult();
			result.setRound(round);
			towerCrossResultDao.add(result);
		}
		return result;
	}
	
	public void update(TowerCrossResult result) {
		towerCrossResultDao.update(result);
	}
}
