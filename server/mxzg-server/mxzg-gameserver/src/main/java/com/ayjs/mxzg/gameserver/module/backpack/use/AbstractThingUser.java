package com.ayjs.mxzg.gameserver.module.backpack.use;

import com.ayjs.mxzg.config.excel.entity.CItem;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.gameserver.module.backpack.service.Rewards;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import org.springframework.beans.factory.annotation.Autowired;

/**
 * 抽象通用物品使用
 */
public abstract class AbstractThingUser implements ThingUse {

    @Autowired
    private ThingService thingService;

    @Override
    public Rewards use(long rid, CItem cItem, int num, GameEvent event) {
        thingService.cost(rid, ImmutableThing.of(cItem.getIdx(), num), GameEvent.USE_ITEM);
        long addNum = cItem.getUse_value() * num;
        return thingService.add(rid, ImmutableThing.of(getRewardItemRefId(), addNum), GameEvent.USE_ITEM);
    }

    public abstract int getRewardItemRefId();
}
