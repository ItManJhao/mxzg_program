package com.ayjs.mxzg.gameserver.module.backpack.service.processor;

import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.gameserver.module.backpack.service.Rewards;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingProcessor;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingSet;
import com.ayjs.mxzg.gameserver.module.spaceTimeAdventure.service.SpaceTimeInfoService;
import com.ayjs.mxzg.template.constant.ErrorCode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

/**
 * 时空冒险航队经验值
 * @author hyx
 */
@Component
public class FleetExpProcessor implements ThingProcessor {

    @Autowired
    private SpaceTimeInfoService spaceTimeInfoService;

    @Override
    public ThingType thingType() {
        return ThingType.FLEET_EXP;
    }

    @Override
    public ErrorCode notEnoughCode() {
        throw new UnsupportedOperationException("不能扣除航队经验值");
    }

    @Override
    public long getCount(long rid, int thingType) {
        throw new UnsupportedOperationException("不能扣除航队经验值");
    }

    @Override
    public Rewards add(long rid, ThingSet thingSet, GameEvent gameEvent) {
        for (ImmutableThing immutableThing : thingSet.asList()) {
            spaceTimeInfoService.addExp(rid, immutableThing.getItem_num());
        }
        return Rewards.of(thingSet);
    }

    @Override
    public ThingSet prepareCost(long rid, ThingSet thingSet, GameEvent gameEvent) {
        throw new UnsupportedOperationException("不能扣除航队经验值");
    }

    @Override
    public void cost(long rid, ThingSet thingSet, GameEvent gameEvent) {
        throw new UnsupportedOperationException("不能扣除航队经验值");
    }
}
