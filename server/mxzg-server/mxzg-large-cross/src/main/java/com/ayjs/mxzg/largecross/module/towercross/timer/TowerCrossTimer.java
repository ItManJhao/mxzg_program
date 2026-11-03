/**
 * 
 */
package com.ayjs.mxzg.largecross.module.towercross.timer;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.ayjs.mxzg.largecross.module.towercross.service.TowerCrossSystemService;
import com.ayjs.mxzg.template.scheduler.service.AbstractCronTask;

/**
 * @author YY
 *
 */
@Component
public class TowerCrossTimer extends AbstractCronTask {

	@Autowired
	private TowerCrossSystemService towerCrossSystemService;
	
	@Override
	public Object identity() {
		return "TowerCrossTimer";
	}

	@Override
	public String expression() {
		return "0/1 * * * * ?";
	}

	@Override
	public void run() {
		towerCrossSystemService.runForThread();
	}
}
