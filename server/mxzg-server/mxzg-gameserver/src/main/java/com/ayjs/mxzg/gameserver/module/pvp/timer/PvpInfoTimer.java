/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.pvp.timer;

import com.ayjs.mxzg.gameserver.module.pvp.service.PvpSysInfoService;
import com.ayjs.mxzg.template.scheduler.service.AbstractCronTask;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

/**
 * @author YY
 *
 */
@Component
public class PvpInfoTimer extends AbstractCronTask {

	@Autowired
	private PvpSysInfoService pvpSysInfoService;
	
	@Override
	public Object identity() {
		return "PvpInfoTimer";
	}

	@Override
	public String expression() {
		return "0/2 *  * * * ?";
	}

	@Override
	public void run() {
		pvpSysInfoService.runForPvp();
	}

}
