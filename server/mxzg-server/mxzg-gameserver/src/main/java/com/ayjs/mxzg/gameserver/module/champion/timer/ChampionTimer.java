/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.champion.timer;

import com.ayjs.mxzg.gameserver.module.champion.service.ChampionService;
import com.ayjs.mxzg.template.scheduler.service.AbstractCronTask;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

/**
 * @author YY
 *
 */
@Component
public class ChampionTimer extends AbstractCronTask {

	@Autowired
	private ChampionService championService;
	
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
