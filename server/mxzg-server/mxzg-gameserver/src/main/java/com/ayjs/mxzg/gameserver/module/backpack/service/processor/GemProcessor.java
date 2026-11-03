/**
 *
 */
package com.ayjs.mxzg.gameserver.module.backpack.service.processor;

import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.ItemType;
import com.ayjs.mxzg.gameserver.module.backpack.event.GemAddEvent;
import com.ayjs.mxzg.gameserver.module.backpack.event.GemCostEvent;
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
public class GemProcessor implements ThingProcessor {

    @Autowired
    private RoleService roleService;
    @Autowired
    private EventBus eventBus;

    @Override
    public long getCount(long rid, int thingType) {
        return getCount(rid);
    }

    private long getCount(long rid) {
        Role role = roleService.getOrThrow(rid);
        return role.getGem();
    }

    @Override
    public ThingType thingType() {
        return ThingType.GEM;
    }

    @Override
    public Rewards add(long rid, ThingSet thingSet, GameEvent gameEvent) {
        long totalReward = combine(thingSet);
        Role role = roleService.getOrThrow(rid);
        role.setGem(role.getGem() + totalReward);
        roleService.updateRole(role);
        
        eventBus.post(GemAddEvent.of(role.getId(), totalReward, gameEvent, role.getGem()));
        
        return Rewards.of(thingSet);
    }

    @Override
    public ThingSet prepareCost(long rid, ThingSet thingSet, GameEvent gameEvent) {
        long total = combine(thingSet);
        ThingProcessor.requireRemainCountGeZero(getCount(rid) - total, ItemType.IT_GEM, notEnoughCode());
        return total > 0L ? ThingSet.of(Lists.newArrayList(
                ImmutableThing.of(ItemType.IT_GEM, total))) : ThingSet.of();
    }

    @Override
    public void cost(long rid, ThingSet thingSet, GameEvent gameEvent) {
        long totalCost = combine(thingSet);
        Role role = roleService.getOrThrow(rid);
        role.setGem(role.getGem() - totalCost);
        roleService.updateRole(role);

        eventBus.post(GemCostEvent.of(role.getId(), totalCost, gameEvent, role.getGem()));
    }

    @Override
    public ErrorCode notEnoughCode() {
        return ErrorCode.BAG_GEM_LACK;
    }
}
