/**
 *
 */
package com.ayjs.mxzg.gameserver.module.backpack.service.processor;

import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.util.IThing;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.ItemType;
import com.ayjs.mxzg.gameserver.module.backpack.event.GoldAddEvent;
import com.ayjs.mxzg.gameserver.module.backpack.event.GoldCostEvent;
import com.ayjs.mxzg.gameserver.module.backpack.service.Rewards;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingProcessor;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingSet;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.template.constant.ErrorCode;
import com.google.common.collect.Lists;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

/**
 * @author YY
 *
 */
@Component
public class GoldProcessor implements ThingProcessor {

    @Autowired
    private RoleService roleService;
    @Autowired
    private EventBus eventBus;

    @Override
    public ThingType thingType() {
        return ThingType.GOLD;
    }

    @Override
    public long getCount(long rid, int thingType) {
        return getCount(rid);
    }


    private long getCount(long rid) {
        Role role = roleService.getOrThrow(rid);
        return role.getGold();
    }

    @Override
    public Rewards add(long rid, ThingSet thingSet, GameEvent gameEvent) {
        long totalReward = 0;
        for (IThing reward : thingSet.asList()) {
            totalReward += reward.getNum();
        }
        Role role = roleService.getOrThrow(rid);
        role.setGold(role.getGold() + totalReward);
        roleService.updateRole(role);
        
        eventBus.post(GoldAddEvent.of(role.getId(), totalReward, gameEvent, role.getGold()));
        
        return Rewards.of(thingSet);
    }

    @Override
    public ThingSet prepareCost(long rid, ThingSet thingSet, GameEvent gameEvent) {
        long total = combine(thingSet);
        ThingProcessor.requireRemainCountGeZero(getCount(rid) - total, ItemType.IT_GOLD, notEnoughCode());
        return total > 0L ? ThingSet.of(Lists.newArrayList(
                ImmutableThing.of(ItemType.IT_GOLD, total))) : ThingSet.of();
    }

    @Override
    public void cost(long rid, ThingSet costList, GameEvent gameEvent) {
        long totalCost = 0;
        for (IThing cost : costList.asList()) {
            totalCost += cost.getNum();
        }
        Role role = roleService.getOrThrow(rid);
        role.setGold(role.getGold() - totalCost);
        roleService.updateRole(role);
        
        eventBus.post(GoldCostEvent.of(role.getId(), totalCost, gameEvent, role.getGold()));
    }

    @Override
    public ErrorCode notEnoughCode() {
        return ErrorCode.BAG_GOLD_LACK;
    }

}
