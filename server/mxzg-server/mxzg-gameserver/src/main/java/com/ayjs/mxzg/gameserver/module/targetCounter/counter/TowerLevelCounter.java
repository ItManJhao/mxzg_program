package com.ayjs.mxzg.gameserver.module.targetCounter.counter;

import com.ayjs.mxzg.config.struct.TargetStruct;
import com.ayjs.mxzg.config.struct.TargetType;
import com.ayjs.mxzg.gameserver.module.tower.service.TowerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

/**
 * @Author: CWJ
 * @Date: 2019/10/28
 **/
@Controller
public class TowerLevelCounter implements Counter {

    @Autowired
    private TowerService towerService;

    @Override
    public TargetType thisType() {
        return TargetType.TOWER_LEVEL;
    }

    @Override
    public int count(long rid, TargetStruct targetStruct) {
        return towerService.getTower(rid).getStage() - 1;
    }

    @Override
    public long taskCount(long rid, TargetStruct targetStruct) {
        return count(rid, targetStruct);
    }
}
