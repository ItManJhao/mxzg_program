package com.ayjs.mxzg.gameserver.module.backpack.service.processor;

import com.ayjs.mxzg.common.util.DropUtil;
import com.ayjs.mxzg.config.excel.cache.spaceTime.SpaceTimeBoxSysCache;
import com.ayjs.mxzg.config.excel.entity.spaceTime.CSpaceTimeBox;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.gameserver.module.backpack.service.Rewards;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingProcessor;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingSet;
import com.ayjs.mxzg.gameserver.module.spaceTimeAdventure.service.SpaceTimeInfoService;
import com.ayjs.mxzg.template.constant.ErrorCode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.List;

/**
 * 时空冒险物资箱
 *
 * @author hyx
 */
@Component
public class FleetBoxProcessor implements ThingProcessor {

    @Autowired
    private SpaceTimeInfoService spaceTimeInfoService;
    @Autowired
    private SpaceTimeBoxSysCache spaceTimeBoxSysCache;

    @Override
    public ThingType thingType() {
        return ThingType.FLEET_BOX;
    }

    @Override
    public ErrorCode notEnoughCode() {
        throw new UnsupportedOperationException("不能扣除物资箱");
    }

    @Override
    public long getCount(long rid, int thingType) {
        throw new UnsupportedOperationException("不能扣除物资箱");
    }

    @Override
    public Rewards add(long rid, ThingSet thingSet, GameEvent gameEvent) {
        for (ImmutableThing immutableThing : thingSet.asList()) {
            for (int i = 0; i < immutableThing.getItem_num(); i++) {
                CSpaceTimeBox cSpaceTimeBox = DropUtil.randomDrop(spaceTimeBoxSysCache.getMap(immutableThing.getItem_type()));
                spaceTimeInfoService.addFleetBox(rid, cSpaceTimeBox.getIdx());
            }
        }
        return Rewards.of(thingSet);
    }

    @Override
    public ThingSet prepareCost(long rid, ThingSet thingSet, GameEvent gameEvent) {
        throw new UnsupportedOperationException("不能扣除物资箱");
    }

    @Override
    public void cost(long rid, ThingSet thingSet, GameEvent gameEvent) {
        throw new UnsupportedOperationException("不能扣除物资箱");
    }

}
