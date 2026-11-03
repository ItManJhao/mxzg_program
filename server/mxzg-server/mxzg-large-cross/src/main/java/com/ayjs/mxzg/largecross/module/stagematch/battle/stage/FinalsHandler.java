package com.ayjs.mxzg.largecross.module.stagematch.battle.stage;

import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.config.excel.entity.CSuperStageCycle;
import com.ayjs.mxzg.config.struct.StageType;
import com.ayjs.mxzg.largecross.module.stagematch.pinnacle.event.OpenPinnacleEvent;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

/**
 * 决赛
 */
@Component
public class FinalsHandler implements StageHandler {

    @Autowired
    private EventBus eventBus;

    @Override
    public StageType getType() {
        return StageType.FINALS;
    }

    @Override
    public void handle(CSuperStageCycle cycle) {
        eventBus.post(OpenPinnacleEvent.getInstance());
    }
}
