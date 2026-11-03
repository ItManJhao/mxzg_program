package com.ayjs.mxzg.gameserver.module.backpack.service.processor;

import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.config.excel.cache.reiki.ReikiEquipSysCache;
import com.ayjs.mxzg.config.excel.entity.reiki.CReikiEquip;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.gameserver.module.backpack.service.Rewards;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingProcessor;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingSet;
import com.ayjs.mxzg.gameserver.module.reikiEquip.domain.ReikiEquip;
import com.ayjs.mxzg.gameserver.module.reikiEquip.event.ReikiEquipAddEvent;
import com.ayjs.mxzg.gameserver.module.reikiEquip.service.ReikiEquipService;
import com.ayjs.mxzg.template.constant.ErrorCode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;

/**
 * 灵器
 *
 * @author hyx
 */
@Component
public class ReikiEquipProcessor implements ThingProcessor {

    @Autowired
    private ReikiEquipService reikiEquipService;
    @Autowired
    private ReikiEquipSysCache reikiEquipSysCache;
    @Autowired
    private EventBus eventBus;

    @Override
    public ThingType thingType() {
        return ThingType.REIKI_EQUIP;
    }

    @Override
    public ErrorCode notEnoughCode() {
        throw new UnsupportedOperationException("不能扣除灵器");
    }

    @Override
    public long getCount(long rid, int thingType) {
        throw new UnsupportedOperationException("不能扣除灵器");
    }

    @Override
    public Rewards add(long rid, ThingSet thingSet, GameEvent gameEvent) {
        List<ReikiEquip> reikiEquipList = new ArrayList<>();
        for (ImmutableThing immutableThing : thingSet.asList()) {
            CReikiEquip cReikiEquip = reikiEquipSysCache.getOrThrow(immutableThing.getItem_type());
            for (int i = 0; i < immutableThing.getItem_num(); i++) {
                ReikiEquip reikiEquip = reikiEquipService.add(cReikiEquip.getIdx(), rid);
                reikiEquipList.add(reikiEquip);
            }
        }
        if (!reikiEquipList.isEmpty()) {
            eventBus.post(ReikiEquipAddEvent.of(rid, reikiEquipList, gameEvent));
        }
        return Rewards.of(thingSet);
    }

    @Override
    public ThingSet prepareCost(long rid, ThingSet thingSet, GameEvent gameEvent) {
        throw new UnsupportedOperationException("不能扣除灵器");
    }

    @Override
    public void cost(long rid, ThingSet thingSet, GameEvent gameEvent) {
        throw new UnsupportedOperationException("不能扣除灵器");
    }
}
