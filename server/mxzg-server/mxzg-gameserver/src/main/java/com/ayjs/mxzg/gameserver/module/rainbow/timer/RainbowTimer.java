/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.rainbow.timer;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.ayjs.mxzg.gameserver.module.rainbow.service.RainbowService;
import com.ayjs.mxzg.template.scheduler.service.AbstractCronTask;

/**
 * @author YY
 *
 */
@Component
public class RainbowTimer extends AbstractCronTask {

	@Autowired
    private RainbowService rainbowService;

    @Override
    public Object identity() {
        return "RainbowTimer";
    }

    @Override
    public String expression() {
        return "0/10 * * * * ?";
    }

    @Override
    public void run() {
    	rainbowService.runForRainbow();
    }
}
