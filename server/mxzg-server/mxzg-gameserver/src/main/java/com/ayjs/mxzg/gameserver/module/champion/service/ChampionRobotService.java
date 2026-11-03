/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.champion.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ayjs.mxzg.gameserver.module.champion.dao.ChampionRobotDao;
import com.ayjs.mxzg.gameserver.module.champion.domain.ChampionRobot;

/**
 * @author YY
 *
 */
@Service
public class ChampionRobotService {

	@Autowired
	private ChampionRobotDao championRobotDao;
	
	public ChampionRobot getRobot(long rbid) {
		ChampionRobot robot = championRobotDao.get("rbid", rbid);
		if(robot == null) {
			robot = new ChampionRobot();
			robot.setRbid(rbid);
			championRobotDao.add(robot);
		}
		return robot;
	}
	
	public void updateRobot(ChampionRobot robot) {
		championRobotDao.update(robot);
	}
}
