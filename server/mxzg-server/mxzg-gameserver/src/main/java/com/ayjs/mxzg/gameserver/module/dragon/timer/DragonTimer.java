/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.dragon.timer;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.ayjs.mxzg.gameserver.module.dragon.service.DragonService;
import com.ayjs.mxzg.template.scheduler.service.AbstractCronTask;

/**
 * @author YY
 *
 */
@Component
public class DragonTimer extends AbstractCronTask {

	@Autowired
	private DragonService dragonService;
	
	@Override
	public Object identity() {
		return "DragonTimer";
	}

	@Override
	public String expression() {
		return "0/1 * * * * ?";
	}

	@Override
	public void run() {
		dragonService.runForCheck();
	}

}
