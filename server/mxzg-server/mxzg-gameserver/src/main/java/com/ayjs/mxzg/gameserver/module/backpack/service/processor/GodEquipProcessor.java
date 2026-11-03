/**
 *
 */
package com.ayjs.mxzg.gameserver.module.backpack.service.processor;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.ayjs.mxzg.config.excel.cache.god.GodEquipmentRandomAbilityTypeSysCache;
import com.ayjs.mxzg.config.excel.cache.god.GodEquipmentRareSysCache;
import com.ayjs.mxzg.config.excel.cache.god.GodEquipmentSysCache;
import com.ayjs.mxzg.config.excel.entity.god.CGodEquipment;
import com.ayjs.mxzg.config.excel.entity.god.CGodEquipmentRare;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.gameserver.module.backpack.service.Rewards;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingProcessor;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingSet;
import com.ayjs.mxzg.gameserver.module.godequip.domain.GodEquip;
import com.ayjs.mxzg.gameserver.module.godequip.service.GodEquipService;
import com.ayjs.mxzg.template.constant.ErrorCode;

/**
 * @author YY
 * 神装
 */
@Component
public class GodEquipProcessor implements ThingProcessor {

    @Autowired
    private GodEquipService godEquipService;
    @Autowired
    private GodEquipmentSysCache godEquipmentSysCache;
    @Autowired
    private GodEquipmentRandomAbilityTypeSysCache godEquipmentRandomAbilityTypeSysCache;
    @Autowired
    private GodEquipmentRareSysCache godEquipmentRareSysCache;

    @Override
    public ThingType thingType() {
        return ThingType.GOD_EQUIP;
    }

    @Override
    public ErrorCode notEnoughCode() {
        throw new UnsupportedOperationException("不能扣除神装");
    }

    @Override
    public long getCount(long rid, int thingType) {
        throw new UnsupportedOperationException("不能扣除神装");
    }

    @Override
    public Rewards add(long rid, ThingSet thingSet, GameEvent gameEvent) {
        List<GodEquip> equips = new ArrayList<>();
        for (ImmutableThing reward : thingSet.asList()) {
            CGodEquipment cGodEquipment = godEquipmentSysCache.getOrThrow(reward.getItem_type());
            CGodEquipmentRare cGodEquipmentRare = godEquipmentRareSysCache.getOrThrow(cGodEquipment.getRare());

            for (int i = 0; i < reward.getItem_num(); i++) {
                GodEquip godEquip = new GodEquip();
                godEquip.setRid(rid);
                godEquip.setPlace(cGodEquipment.getPlace());
                godEquip.setSysId(cGodEquipment.getEquipment_type());
                godEquip.setAttrs(godEquipmentRandomAbilityTypeSysCache.randomAttr(cGodEquipmentRare, cGodEquipment.getPlace()));
                godEquip.setWashAttrs(new ArrayList<>());
                godEquip.setHeroId(0);
                equips.add(godEquip);
            }
        }
        godEquipService.addEquips(equips, gameEvent);
        return Rewards.ofGodEquips(thingSet, equips);
    }

    @Override
    public ThingSet prepareCost(long rid, ThingSet thingSet, GameEvent gameEvent) {
        throw new UnsupportedOperationException("不能扣除神装");
    }

    @Override
    public void cost(long rid, ThingSet thingSet, GameEvent gameEvent) {
        throw new UnsupportedOperationException("不能扣除神装");
    }
}
