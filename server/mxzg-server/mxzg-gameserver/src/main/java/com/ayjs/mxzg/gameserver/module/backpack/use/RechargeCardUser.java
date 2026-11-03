package com.ayjs.mxzg.gameserver.module.backpack.use;

import com.ayjs.mxzg.config.excel.entity.CItem;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.gameserver.module.backpack.service.Rewards;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

/**
 * @author Rondo
 * 2021-06-02 15:23:46
 */
@Component
public class RechargeCardUser implements ThingUse {

    @Autowired
    private ThingService thingService;

    @Override
    public ThingUseType getType() {
        return ThingUseType.RECHARGE_CARD;
    }

    @Override
    public Rewards use(long rid, CItem cItem, int num, GameEvent event) {
        // 奖励已在RoleRechargeService的接口统一发放，此处只做扣减道具
        ImmutableThing cost = ImmutableThing.of(cItem.getIdx(), num, 0);

        thingService.cost(rid, cost, event);
        return Rewards.of();
    }
}
