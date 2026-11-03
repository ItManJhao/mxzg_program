package com.ayjs.mxzg.gameserver.module.backpack.use;

import com.ayjs.mxzg.config.excel.entity.CItem;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.gameserver.module.backpack.service.Rewards;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingSet;
import com.ayjs.mxzg.gameserver.module.battle.service.RoleMissionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

/**
 * 挂机礼包
 */
@Component
public class IdleGiftPackageUser implements ThingUse {
    @Autowired
    private ThingService thingService;
    @Autowired
    private RoleMissionService roleMissionService;

    @Override
    public ThingUseType getType() {
        return ThingUseType.IDLE_GIFT_PACKAGE;
    }

    @Override
    public Rewards use(long rid, CItem cItem, int num, GameEvent event) {
        int useValue = cItem.getUse_value();
        ImmutableThing cost = ImmutableThing.of(cItem.getIdx(), num, 0);
        thingService.cost(rid, cost, event);

        return Rewards.of(ThingSet.of(roleMissionService.idleBattleReward(rid, useValue)));
    }
}
