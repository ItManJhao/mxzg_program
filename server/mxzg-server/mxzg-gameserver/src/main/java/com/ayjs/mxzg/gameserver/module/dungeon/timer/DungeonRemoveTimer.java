package com.ayjs.mxzg.gameserver.module.dungeon.timer;

import com.ayjs.mxzg.gameserver.module.dungeon.service.DungeonInfoService;
import com.ayjs.mxzg.template.scheduler.service.AbstractCronTask;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

/**
 * 地牢塔层回退定时器
 */
@Component
public class DungeonRemoveTimer extends AbstractCronTask {

    @Autowired
    private DungeonInfoService dungeonInfoService;

    @Override
    public Object identity() {
        return "DungeonRemoveTimer";
    }

    @Override
    public String expression() {
        return "0 0 0 * * ?";
    }

    @Override
    public void run() {
        dungeonInfoService.getShelterStarTime();
    }
}
