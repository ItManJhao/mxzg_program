/**
 *
 */
package com.ayjs.mxzg.gameserver.module.backpack.service.processor;

import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.ItemType;
import com.ayjs.mxzg.gameserver.module.backpack.event.SuperGemAddEvent;
import com.ayjs.mxzg.gameserver.module.backpack.event.SuperGemCostEvent;
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
 * 超级钻石
 * @author tangyangbo
 *
 */
@Component
public class SuperGemProcessor implements ThingProcessor {

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
        return role.getSuperGem();
    }

    @Override
    public ThingType thingType() {
        return ThingType.SUPER_GEM;
    }

    @Override
    public Rewards add(long rid, ThingSet thingSet, GameEvent gameEvent) {
        long totalReward = combine(thingSet);
        Role role = roleService.getOrThrow(rid);
        role.setSuperGem(role.getSuperGem() + totalReward);
        roleService.updateRole(role);

        eventBus.post(SuperGemAddEvent.of(role.getId(), totalReward, gameEvent, role.getSuperGem()));

        return Rewards.of(thingSet);
    }

    @Override
    public ThingSet prepareCost(long rid, ThingSet thingSet, GameEvent gameEvent) {
        long total = combine(thingSet);
        ThingProcessor.requireRemainCountGeZero(getCount(rid) - total, ItemType.IT_SUPER_GEM, notEnoughCode());
        return total > 0L ? ThingSet.of(Lists.newArrayList(
                ImmutableThing.of(ItemType.IT_SUPER_GEM, total))) : ThingSet.of();
    }

    @Override
    public void cost(long rid, ThingSet thingSet, GameEvent gameEvent) {
        long totalCost = combine(thingSet);
        Role role = roleService.getOrThrow(rid);
        role.setSuperGem(role.getSuperGem() - totalCost);
        roleService.updateRole(role);

        eventBus.post(SuperGemCostEvent.of(role.getId(), totalCost, gameEvent, role.getSuperGem()));
    }

    @Override
    public ErrorCode notEnoughCode() {
        return ErrorCode.BAG_SUPER_GEM_LACK;
    }
}
