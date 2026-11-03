package com.ayjs.mxzg.gameserver.module.backpack.service.processor;

import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.IThing;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.ItemType;
import com.ayjs.mxzg.gameserver.module.backpack.event.ItemAddEvent;
import com.ayjs.mxzg.gameserver.module.backpack.event.ItemCostEvent;
import com.ayjs.mxzg.gameserver.module.backpack.service.Rewards;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingProcessor;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingSet;
import com.ayjs.mxzg.gameserver.module.crusadegroup.group.domain.RoleCrusadeGroup;
import com.ayjs.mxzg.gameserver.module.crusadegroup.group.service.GroupService;
import com.ayjs.mxzg.gameserver.module.crusadegroup.occupation.event.ShenBinAddEvent;
import com.ayjs.mxzg.gameserver.module.crusadegroup.occupation.event.ShenBinItemAddEvent;
import com.ayjs.mxzg.template.constant.ErrorCode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.HashMap;
import java.util.Map;

@Component
public class ShenBinProcessor implements ThingProcessor {

    @Autowired
    private GroupService groupService;
    @Autowired
    private EventBus eventBus;

    @Override
    public ThingType thingType() {
        return ThingType.SHENBIN;
    }

    @Override
    public ErrorCode notEnoughCode() {
        return ErrorCode.SHENBIN_NOT_ENOUGH;
    }

    @Override
    public long getCount(long rid, int thingType) {
        RoleCrusadeGroup roleCrusadeGroup = groupService.getRoleCrusadeGroup(rid);
        //神兵精华
        if (thingType == ItemType.SHENBIN_ESSENCE) {
            return roleCrusadeGroup.getForceNature();
        }
        //神兵
        return roleCrusadeGroup.getShenBinMap().getOrDefault(thingType, 0l);
    }

    @Override
    public Rewards add(long rid, ThingSet thingSet, GameEvent gameEvent) {
        RoleCrusadeGroup roleCrusadeGroup = groupService.getRoleCrusadeGroup(rid);
        Map<Integer, Long> bagMap = roleCrusadeGroup.getShenBinMap();
        Map<Integer, Long> currMap = new HashMap<>();
        long shenBinItemAddAll = 0;//神兵精华总数
        Map<Integer, Long> addShenBinMap = new HashMap<>();//添加的神兵信息
        for (ImmutableThing reward : thingSet.asList()) {
            int item_type = reward.getThingId();
            if (item_type == ItemType.SHENBIN_ESSENCE) {//神兵精华
                long num = roleCrusadeGroup.getForceNature();
                roleCrusadeGroup.setForceNature(num + reward.getNum());
                currMap.put(item_type, roleCrusadeGroup.getForceNature());
                shenBinItemAddAll += reward.getNum();
            } else {
                long num = bagMap.getOrDefault(item_type, 0l);
                bagMap.put(item_type, num + reward.getNum());
                currMap.put(item_type, bagMap.get(item_type));
                addShenBinMap.put(item_type, reward.getNum());
            }
        }
        groupService.updateRoleCrusadeGroup(roleCrusadeGroup);
        eventBus.post(ItemAddEvent.of(rid, thingSet.asList(), gameEvent, currMap));
        if (shenBinItemAddAll > 0) {
            eventBus.post(ShenBinItemAddEvent.of(rid, shenBinItemAddAll, gameEvent));
        }
        if (!addShenBinMap.isEmpty()) {
            eventBus.post(ShenBinAddEvent.of(rid, addShenBinMap));
        }
        return Rewards.of(thingSet);
    }

    @Override
    public ThingSet prepareCost(long rid, ThingSet thingSet, GameEvent gameEvent) {
        requireValid(thingSet);
        RoleCrusadeGroup roleCrusadeGroup = groupService.getRoleCrusadeGroup(rid);
        Map<Integer, Long> bagMap = roleCrusadeGroup.getShenBinMap();
        thingSet.asList().forEach(thing -> {
            int item_type = thing.getItem_type();
            long num = 0;
            if (item_type == ItemType.SHENBIN_ESSENCE) {//神兵精华
                num = roleCrusadeGroup.getForceNature();
            } else {
                num = bagMap.getOrDefault(item_type, 0l);
            }
            Asserts.isTrue(num > 0, notEnoughCode().getValue(),
                    () -> String.format("item_type:%s item_num <= 0 item_num:%s"
                            , thing.getItem_type(), thing.getItem_num()));
            Asserts.isTrue(thing.getItem_num() > 0, notEnoughCode().getValue(),
                    () -> String.format("item_type:%s item_num <= 0 item_num:%s"
                            , thing.getItem_type(), thing.getItem_num()));
            ThingProcessor.requireRemainCountGeZero(
                    num - thing.getItem_num(), thing.getItem_type(), notEnoughCode());
        });
        return thingSet;
    }

    @Override
    public void cost(long rid, ThingSet thingSet, GameEvent gameEvent) {
        RoleCrusadeGroup roleCrusadeGroup = groupService.getRoleCrusadeGroup(rid);
        Map<Integer, Long> bagMap = roleCrusadeGroup.getShenBinMap();
        Map<Integer, Long> currMap = new HashMap<>();
        for (IThing cost : thingSet.asList()) {
            int item_type = cost.getThingId();
            if (item_type == ItemType.SHENBIN_ESSENCE) {//神兵精华
                long num = roleCrusadeGroup.getForceNature();
                roleCrusadeGroup.setForceNature(num - cost.getNum());
                currMap.put(cost.getThingId(), roleCrusadeGroup.getForceNature());
            } else {
                long num = bagMap.getOrDefault(item_type, 0l);
                if (num - cost.getNum() <= 0) {
                    bagMap.remove(cost.getThingId());
                } else {
                    bagMap.put(cost.getThingId(), num - cost.getNum());
                }
                currMap.put(cost.getThingId(), bagMap.getOrDefault(cost.getThingId(), 0l));
            }
        }
        groupService.updateRoleCrusadeGroup(roleCrusadeGroup);
        eventBus.post(ItemCostEvent.of(rid, thingSet.asList(), gameEvent, currMap));
    }
}
