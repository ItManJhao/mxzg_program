package com.ayjs.mxzg.gameserver.module.backpack.service.processor;

import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.IThing;
import com.ayjs.mxzg.common.util.ListMapUtil;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.gameserver.module.backpack.domain.BackPack;
import com.ayjs.mxzg.gameserver.module.backpack.event.ItemAddEvent;
import com.ayjs.mxzg.gameserver.module.backpack.event.ItemCostEvent;
import com.ayjs.mxzg.gameserver.module.backpack.service.BackPackService;
import com.ayjs.mxzg.gameserver.module.backpack.service.Rewards;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingProcessor;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingSet;
import com.ayjs.mxzg.template.constant.ErrorCode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.*;

/**
 * 皮肤（时装）
 *
 * @author hyx
 */
@Component
public class FashionProcessor implements ThingProcessor {

    @Autowired
    private BackPackService backPackService;
    @Autowired
    private EventBus eventBus;

    @Override
    public ThingType thingType() {
        return ThingType.FASHION;
    }

    @Override
    public ErrorCode notEnoughCode() {
        return ErrorCode.BAG_ITEM_LACK;
    }

    @Override
    public long getCount(long rid, int thingType) {
        List<BackPack> bagList = backPackService.getBagList(rid);
        Map<Integer, BackPack> bagMap = ListMapUtil.listToMap(bagList, BackPack::getItemId);
        BackPack backPack = bagMap.get(thingType);

        if (Objects.isNull(backPack)) {
            return 0;
        } else {
            return backPack.getNum();
        }
    }

    @Override
    public Rewards add(long rid, ThingSet thingSet, GameEvent gameEvent) {
        List<BackPack> bagList = backPackService.getBagList(rid);
        Map<Integer, BackPack> bagMap = ListMapUtil.listToMap(bagList, BackPack::getItemId);

        List<BackPack> addList = null;
        List<BackPack> updateList = null;

        Map<Integer, Long> currMap = new HashMap<>();

        for (ImmutableThing reward : thingSet.asList()) {
            BackPack backPack = bagMap.get(reward.getThingId());
            if (backPack == null) {
                backPack = new BackPack();
                backPack.setRid(rid);
                backPack.setItemId(reward.getThingId());
                backPack.setNum(reward.getNum());
                bagMap.put(reward.getThingId(), backPack);
                if (addList == null) {
                    addList = new ArrayList<>();
                }
                addList.add(backPack);
            } else {
                backPack.setNum(backPack.getNum() + reward.getNum());
                if (updateList == null) {
                    updateList = new ArrayList<>();
                }
                updateList.add(backPack);
            }
            currMap.put(backPack.getItemId(), backPack.getNum());
        }
        if (addList != null) {
            backPackService.addBackPacks(addList);
        }
        if (updateList != null) {
            backPackService.updateBackPacks(updateList);
        }
        eventBus.post(ItemAddEvent.of(rid, thingSet.asList(), gameEvent, currMap));
        return Rewards.of(thingSet);
    }

    @Override
    public ThingSet prepareCost(long rid, ThingSet thingSet, GameEvent gameEvent) {
        requireValid(thingSet);
        List<BackPack> bagList = backPackService.getBagList(rid);
        Map<Integer, BackPack> bagMap = ListMapUtil.listToMap(bagList, BackPack::getItemId);
        thingSet.asList().forEach(thing -> {
            BackPack backPack = bagMap.get(thing.getItem_type());
            Asserts.notNull(backPack, notEnoughCode().getValue(),
                    () -> String.format("item_type:%s not enough need:%s have 0"
                            , thing.getItem_type(), thing.getItem_num()));
            ThingProcessor.requireRemainCountGeZero(
                    backPack.getNum() - thing.getItem_num(), thing.getItem_type(), notEnoughCode());
        });
        return thingSet;
    }

    @Override
    public void cost(long rid, ThingSet thingSet, GameEvent gameEvent) {
        List<BackPack> bagList = backPackService.getBagList(rid);
        Map<Integer, BackPack> bagMap = ListMapUtil.listToMap(bagList, BackPack::getItemId);

        List<BackPack> updateList = new ArrayList<>();

        Map<Integer, Long> currMap = new HashMap<>();

        for (IThing cost : thingSet.asList()) {
            BackPack backPack = bagMap.get(cost.getThingId());
            backPack.setNum(backPack.getNum() - cost.getNum());

            updateList.add(backPack);

            currMap.put(backPack.getItemId(), backPack.getNum());
        }
        backPackService.updateBackPacks(updateList);

        eventBus.post(ItemCostEvent.of(rid, thingSet.asList(), gameEvent, currMap));
    }
}
