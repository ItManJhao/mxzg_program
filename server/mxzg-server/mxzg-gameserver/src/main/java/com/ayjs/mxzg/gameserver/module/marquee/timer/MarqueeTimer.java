/**
 *
 */
package com.ayjs.mxzg.gameserver.module.marquee.timer;

import com.ayjs.mxzg.gameserver.module.marquee.service.MarqueeService;
import com.ayjs.mxzg.template.scheduler.service.AbstractCronTask;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

/**
 * @author YY
 *
 */
@Component
public class MarqueeTimer extends AbstractCronTask {

	@Autowired
	private MarqueeService marqueeService;

	@Override
	public Object identity() {
		return "MarqueeTimer";
	}

	@Override
	public String expression() {
		return "0/1 * * * * ?";
	}

	@Override
	public void run() {
		marqueeService.runForMarquee();
	}
}
