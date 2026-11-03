package com.ayjs.mxzg.gameserver.module.backpack.service.processor;

import com.ayjs.mxzg.common.util.DropUtil;
import com.ayjs.mxzg.config.excel.cache.ItemExChangeSysCache;
import com.ayjs.mxzg.config.excel.cache.god.GodEquipmentRandomAbilityTypeSysCache;
import com.ayjs.mxzg.config.excel.cache.god.GodEquipmentRareSysCache;
import com.ayjs.mxzg.config.excel.cache.god.GodEquipmentSysCache;
import com.ayjs.mxzg.config.excel.entity.CItemExChange;
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
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;

/**
 * 随机神装
 *
 * @author hyx
 */
@Component
public class GodEquipDropProcessor implements ThingProcessor {

    @Autowired
    private ItemExChangeSysCache itemExChangeSysCache;
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
        return ThingType.GOD_EQUIP_CHANCE;
    }

    @Override
    public ErrorCode notEnoughCode() {
        throw new UnsupportedOperationException("不能扣除神装随机道具");
    }

    @Override
    public long getCount(long rid, int thingType) {
        throw new UnsupportedOperationException("不能扣除神装随机道具");
    }

    @Override
    public Rewards add(long rid, ThingSet thingSet, GameEvent gameEvent) {

        List<GodEquip> equips = new ArrayList<>();
        List<ImmutableThing> rewardList = new ArrayList<>();

        for (ImmutableThing reward : thingSet.asList()) {

            for (int i = 0; i < reward.getItem_num(); i++) {

                List<CItemExChange> itemExChangeList = itemExChangeSysCache.getItemList(reward.getItem_type());
                CItemExChange itemExChange = DropUtil.randomDrop(itemExChangeList);
                rewardList.addAll(itemExChange.getReward());

                for (ImmutableThing thing : itemExChange.getReward()) {

                    CGodEquipment cGodEquipment = godEquipmentSysCache.getOrThrow(thing.getItem_type());
                    CGodEquipmentRare cGodEquipmentRare = godEquipmentRareSysCache.getOrThrow(cGodEquipment.getRare());

                    for (int j = 0; j < thing.getItem_num(); j++) {

                        GodEquip godEquip = new GodEquip();
                        godEquip.setRid(rid);
                        godEquip.setPlace(cGodEquipment.getPlace());
                        godEquip.setSysId(cGodEquipment.getEquipment_type());
                        godEquip.setAttrs(godEquipmentRandomAbilityTypeSysCache.randomAttr(cGodEquipmentRare,cGodEquipment.getPlace()));
                        godEquip.setWashAttrs(new ArrayList<>());
                        godEquip.setHeroId(0);
                        equips.add(godEquip);

                    }
                }
            }

        }
        godEquipService.addEquips(equips, gameEvent);
        return Rewards.ofGodEquips(ThingSet.of(rewardList), equips);
    }

    @Override
    public ThingSet prepareCost(long rid, ThingSet thingSet, GameEvent gameEvent) {
        throw new UnsupportedOperationException("不能扣除神装随机道具");
    }

    @Override
    public void cost(long rid, ThingSet thingSet, GameEvent gameEvent) {
        throw new UnsupportedOperationException("不能扣除神装随机道具");
    }

}
