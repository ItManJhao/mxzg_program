/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.stagematch.pinnacle.service;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.lifecycle.Lifecycle;
import com.ayjs.mxzg.common.lifecycle.LifecycleInfo;
import com.ayjs.mxzg.common.lifecycle.Ordinal;
import com.ayjs.mxzg.common.lifecycle.Priority;
import com.ayjs.mxzg.config.excel.constant.PinnaclePeriod;
import com.ayjs.mxzg.gameserver.module.stagematch.pinnacle.dao.PinnacleSystemDao;
import com.ayjs.mxzg.gameserver.module.stagematch.pinnacle.domain.PinnacleSystem;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.concurrent.ConcurrentHashMap;


@Slf4j
@Observer
@Service
public class PinnacleService implements Lifecycle {

	@Autowired
	private PinnacleSystemDao championSystemDao;

	@Override
	public LifecycleInfo getInfo() {
		return LifecycleInfo.valueOf(Priority.MEDIUM, Ordinal._5, "PinnacleService");
	}
	
	public PinnacleSystem getSystem() {
		PinnacleSystem championSystem = null;
		List<PinnacleSystem> systemList = championSystemDao.listAll();
		if(systemList.isEmpty()) {
			championSystem = new PinnacleSystem();
			championSystem.setRound(1);
			championSystem.setPeriod(PinnaclePeriod.IDLE.getValue());
			championSystem.setBattleRound(1);
			
			championSystem.setTopPlayers(new ConcurrentHashMap<>());
			championSystemDao.add(championSystem);
		} else {
			championSystem = systemList.get(0);
		}
		return championSystem;
	}
	

}
