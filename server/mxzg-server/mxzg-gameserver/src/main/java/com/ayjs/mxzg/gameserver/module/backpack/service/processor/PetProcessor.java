
package com.ayjs.mxzg.gameserver.module.backpack.service.processor;

import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.config.excel.cache.pet.PetSysCache;
import com.ayjs.mxzg.config.excel.entity.pet.CPet;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.gameserver.module.backpack.service.Rewards;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingProcessor;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingSet;
import com.ayjs.mxzg.gameserver.module.pet.domain.Pet;
import com.ayjs.mxzg.gameserver.module.pet.service.PetService;
import com.ayjs.mxzg.gameserver.module.pet.event.PetAddEvent;
import com.ayjs.mxzg.template.constant.ErrorCode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;

@Component
public class PetProcessor implements ThingProcessor {

    @Autowired
    private PetService petService;
    @Autowired
    private EventBus eventBus;
    @Autowired
    private PetSysCache petSysCache;

    @Override
    public ThingType thingType() {
        return ThingType.PET;
    }

    @Override
    public ErrorCode notEnoughCode() {
        throw new UnsupportedOperationException("不能扣除宠物");
    }

    @Override
    public long getCount(long rid, int thingType) {
        throw new UnsupportedOperationException("不能扣除宠物");
    }

    @Override
    public ThingSet prepareCost(long rid, ThingSet thingSet, GameEvent gameEvent) {
        throw new UnsupportedOperationException("不能扣除宠物");
    }

    @Override
    public void cost(long rid, ThingSet thingSet, GameEvent gameEvent) {
        throw new UnsupportedOperationException("不能扣除宠物");
    }

    @Override
    public Rewards add(long rid, ThingSet thingSet, GameEvent gameEvent) {
        List<Pet> petList = new ArrayList<>();
        for (ImmutableThing immutableThing : thingSet.asList()) {
            CPet cPet = petSysCache.getOrThrow(immutableThing.getItem_type());
            for (int i = 0; i < immutableThing.getItem_num(); i++) {
                Pet pet = new Pet();
                pet.setHeroId(0);
                pet.setLevel(1);
                pet.setSysId(immutableThing.getItem_type());
                pet.setRid(rid);
                petService.addPet(pet);
                petList.add(pet);
            }
        }
        if (!petList.isEmpty()) {
            eventBus.post(PetAddEvent.of(rid, petList, gameEvent));
        }
        return Rewards.of(thingSet);
    }
}


