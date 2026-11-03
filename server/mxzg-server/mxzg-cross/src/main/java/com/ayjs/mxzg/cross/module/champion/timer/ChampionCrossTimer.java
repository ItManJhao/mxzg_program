/**
 * 
 */
package com.ayjs.mxzg.cross.module.champion.timer;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.ayjs.mxzg.cross.module.champion.service.ChampionCrossService;
import com.ayjs.mxzg.template.scheduler.service.AbstractCronTask;

/**
 * @author YY
 *
 */
@Component
public class ChampionCrossTimer extends AbstractCronTask {

	@Autowired
	private ChampionCrossService championService;
	
	@Override
    public Object identity() {
        return "ChampionTimer";
    }

    @Override
    public String expression() {
        return "0/1 * * * * ?";
    }

    @Override
    public void run() {
    	championService.runForChampion();
    }
}
