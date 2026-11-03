/**
 * 
 */
package com.ayjs.mxzg.cross.module.champion.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ayjs.mxzg.cross.module.champion.dao.ChampionCrossRobotDao;
import com.ayjs.mxzg.cross.module.champion.domain.ChampionCrossRobot;

/**
 * @author YY
 *
 */
@Service
public class ChampionCrossRobotService {

	@Autowired
	private ChampionCrossRobotDao championRobotDao;
	
	public ChampionCrossRobot getRobot(long rbid) {
		ChampionCrossRobot robot = championRobotDao.get("rbid", rbid);
		if(robot == null) {
			robot = new ChampionCrossRobot();
			robot.setRbid(rbid);
			championRobotDao.add(robot);
		}
		return robot;
	}
	
	public void updateRobot(ChampionCrossRobot robot) {
		championRobotDao.update(robot);
	}
}
