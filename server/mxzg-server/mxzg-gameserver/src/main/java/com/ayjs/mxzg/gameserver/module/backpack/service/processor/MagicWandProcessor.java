package com.ayjs.mxzg.gameserver.module.backpack.service.processor;

import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.util.IThing;
import com.ayjs.mxzg.config.excel.cache.MagicWandTypeSysCache;
import com.ayjs.mxzg.config.excel.entity.CMagicWandType;
import com.ayjs.mxzg.config.struct.AttributeType;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.gameserver.module.backpack.event.MagicWandAddEvent;
import com.ayjs.mxzg.gameserver.module.backpack.service.Rewards;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingProcessor;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingSet;
import com.ayjs.mxzg.gameserver.module.hero.domain.HeroMagicWand;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroMagicWandService;
import com.ayjs.mxzg.gameserver.module.hero.struct.MagicAttrData;
import com.ayjs.mxzg.template.constant.ErrorCode;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.*;

/**
 * @author Rondo
 * 2021-05-19 11:42:05
 */
@Slf4j
@Component
public class MagicWandProcessor implements ThingProcessor {

    @Autowired
    private HeroMagicWandService heroMagicWandService;

    @Autowired
    private MagicWandTypeSysCache magicWandTypeSysCache;

    @Autowired
    private EventBus eventBus;

    @Override
    public ThingType thingType() {
        return ThingType.MAGIC_WAND;
    }

    @Override
    public ErrorCode notEnoughCode() {
        return ErrorCode.MAGIC_WAND_NOT_ENOUGH;
    }

    @Override
    public long getCount(long rid, int thingType) {
        HeroMagicWand magicWand = heroMagicWandService.getMagicWand(rid, thingType);
        return Objects.isNull(magicWand) ? 0 : 1;
    }

    @Override
    public Rewards add(long rid, ThingSet thingSet, GameEvent gameEvent) {
        List<HeroMagicWand> list = new ArrayList<>();
        for (IThing reward : thingSet.asList()) {
            for (int i = 0; i < reward.getNum(); i++) {
                CMagicWandType magicWandConfig = magicWandTypeSysCache.getById(reward.getThingId());
                if (magicWandConfig == null) continue;
                HeroMagicWand magicWand = new HeroMagicWand();
                magicWand.setRid(rid);
                magicWand.setTypeId(magicWandConfig.getType_id());
                magicWand.setType(magicWandConfig.getType());
                magicWand.setRare(magicWandConfig.getRare());
                magicWand.setStrengthen(1);
                Map<Integer, MagicAttrData> base_attrs = magicWand.getBase_attrs();
                Map<Integer, MagicAttrData> random_attrs = magicWand.getRandom_attrs();
                for (Map.Entry<AttributeType, Long> entry : magicWandConfig.getBase_attrs().entrySet()) {
                    MagicAttrData newAttr = new MagicAttrData(entry.getKey(), entry.getValue());
                    base_attrs.put(base_attrs.size(), newAttr);
                }
                if (!magicWandConfig.getRandom_attrs().isEmpty()) {
                    int random_index = new Random().nextInt(magicWandConfig.getRandom_attrs().size());
                    int begin = 0;
                    for (Map.Entry<AttributeType, Long> entry : magicWandConfig.getRandom_attrs().entrySet()) {
                        if ((begin++) == random_index) {
                            MagicAttrData newAttr = new MagicAttrData(entry.getKey(), entry.getValue());
                            random_attrs.put(random_attrs.size(), newAttr); // 0 Object
                            break;
                        }
                    }
                }
                list.add(magicWand);
            }
        }
        if (!list.isEmpty()) {
            heroMagicWandService.addHeroMagicWand(list);
            eventBus.post(MagicWandAddEvent.of(rid, list, gameEvent));
        }
        return Rewards.ofHeroMagicWands(ThingSet.of(), list);
    }

    @Override
    public ThingSet prepareCost(long rid, ThingSet thingSet, GameEvent gameEvent) {
        log.debug("消耗魔杖无法使用ThingService方法，需调用 HeroMagicWandService下的prepareCost方法");
        return ThingSet.of();
    }

    @Override
    public void cost(long rid, ThingSet thingSet, GameEvent gameEvent) {
        log.debug("消耗魔杖无法使用ThingService方法，需调用 HeroMagicWandService下的cost方法");
    }
}
