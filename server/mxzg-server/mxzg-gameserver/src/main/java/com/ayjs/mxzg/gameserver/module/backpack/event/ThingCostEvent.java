package com.ayjs.mxzg.gameserver.module.backpack.event;

import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingSet;
import lombok.Value;

@Value(staticConstructor = "of")
public class ThingCostEvent {

    /**
     * 角色id
     */
    private long rid;
    /**
     * 消耗的物品信息
     */
    private ThingSet update;
    /**
     * 事件来源
     */
    private GameEvent event;
}
