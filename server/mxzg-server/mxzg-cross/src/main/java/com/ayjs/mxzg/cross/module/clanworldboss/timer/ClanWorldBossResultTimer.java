/**
 * 
 */
package com.ayjs.mxzg.cross.module.clanworldboss.timer;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.ayjs.mxzg.cross.module.clanworldboss.service.ClanWorldBossResultService;
import com.ayjs.mxzg.template.scheduler.service.AbstractCronTask;

/**
 * @author YY
 *
 */
@Component
public class ClanWorldBossResultTimer extends AbstractCronTask {

	
	@Autowired
	private ClanWorldBossResultService clanWorldBossResultService;
	
	@Override
	public Object identity() {
		return "ClanWorldBossResultTimer";
	}

	@Override
	public String expression() {
		return "0 0/5 * * * ?";
	}

	@Override
	public void run() {
		clanWorldBossResultService.runForResult();
	}
}
