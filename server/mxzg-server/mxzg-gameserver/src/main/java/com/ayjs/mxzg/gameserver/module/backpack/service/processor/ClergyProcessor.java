package com.ayjs.mxzg.gameserver.module.backpack.service.processor;

import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.util.IThing;
import com.ayjs.mxzg.config.excel.cache.HeroTypeSysCache;
import com.ayjs.mxzg.config.excel.entity.CHeroType;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.gameserver.module.backpack.event.ClergyExpAddEvent;
import com.ayjs.mxzg.gameserver.module.backpack.event.GoldAddEvent;
import com.ayjs.mxzg.gameserver.module.backpack.service.Rewards;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingProcessor;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingSet;
import com.ayjs.mxzg.gameserver.module.hero.domain.Hero;
import com.ayjs.mxzg.gameserver.module.hero.event.HeroGetEvent;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroService;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.template.constant.ErrorCode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;

/**
 * 神职经验
 *
 * @author hyx
 */
@Component
public class ClergyProcessor implements ThingProcessor {

    @Autowired
    private RoleService roleService;
    @Autowired
    private EventBus eventBus;

    @Override
    public ThingType thingType() {
        return ThingType.CLERGY_EXP;
    }

    @Override
    public ErrorCode notEnoughCode() {
        throw new UnsupportedOperationException("不能扣除神职经验");
    }

    @Override
    public long getCount(long rid, int thingType) {
        throw new UnsupportedOperationException("不能扣除神职经验");
    }

    @Override
    public Rewards add(long rid, ThingSet thingSet, GameEvent gameEvent) {

        long totalReward = 0;
        for (IThing reward : thingSet.asList()) {
            totalReward += reward.getNum();
        }
        Role role = roleService.getOrThrow(rid);
        role.setClergyExp(role.getClergyExp() + totalReward);
        roleService.updateRole(role);

        eventBus.post(ClergyExpAddEvent.of(role.getId(), totalReward, gameEvent, role.getClergyExp()));

        return Rewards.of(thingSet);

    }

    @Override
    public ThingSet prepareCost(long rid, ThingSet thingSet, GameEvent gameEvent) {
        throw new UnsupportedOperationException("不能扣除神职经验");
    }

    @Override
    public void cost(long rid, ThingSet thingSet, GameEvent gameEvent) {
        throw new UnsupportedOperationException("不能扣除神职经验");
    }


}
