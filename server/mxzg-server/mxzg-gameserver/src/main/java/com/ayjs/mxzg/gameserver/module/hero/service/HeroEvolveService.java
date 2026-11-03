package com.ayjs.mxzg.gameserver.module.hero.service;

import cn.hutool.core.collection.CollectionUtil;
import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.config.excel.cache.HeroEvolveLevelSysCache;
import com.ayjs.mxzg.config.excel.cache.HeroTypeSysCache;
import com.ayjs.mxzg.config.excel.cache.ItemSysCache;
import com.ayjs.mxzg.config.excel.entity.CHeroEvolveLevel;
import com.ayjs.mxzg.config.excel.entity.CHeroType;
import com.ayjs.mxzg.config.excel.entity.CItem;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import com.ayjs.mxzg.gameserver.module.backpack.constant.NoticeType;
import com.ayjs.mxzg.gameserver.module.backpack.service.Rewards;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.backpack.service.processor.ThingType;
import com.ayjs.mxzg.gameserver.module.hero.domain.Hero;
import com.ayjs.mxzg.gameserver.module.hero.event.HeroGetEvent;
import com.ayjs.mxzg.gameserver.module.hero.struct.HeroConsume;
import com.ayjs.mxzg.gameserver.module.util.PbUtil;
import com.ayjs.mxzg.protocol.ObjectGMsg;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.stream.Collectors;

/**
 * 英雄进化
 *
 * @Author: CWJ
 * @Date: 2020/7/15
 **/
@Service
public class HeroEvolveService {

    @Autowired
    private HeroTypeSysCache heroTypeSysCache;
    @Autowired
    private HeroService heroService;
    @Autowired
    private EventBus eventBus;
    @Autowired
    private HeroEvolveLevelSysCache heroEvolveLevelSysCache;
    @Autowired
    private ThingService thingService;
    @Autowired
    private ItemSysCache itemSysCache;

    /***
     * 英雄进化返回
     * @param hero
     */
    public Rewards evolveBack(Hero hero, NoticeType noticeType) {
        //回退进化消耗的英雄
        List<HeroConsume> evolveConsumes = new ArrayList<>();
        if (CollectionUtil.isEmpty(hero.getEvolve().getHadConsume())) {
            return Rewards.of();
        }
        List<ImmutableThing> reward = heroEvolveLevelSysCache.getAll().stream().
                filter(config -> config.getHero_type() == hero.getType() && config.getEvolve_type() == hero.getEvolve().getType()
                        && config.getLevel() <= hero.getEvolve().getLevel()).map(CHeroEvolveLevel::getConsume_item)
                .flatMap(Collection::stream).collect(Collectors.toList());
        reward = ImmutableThingUtil.mergeThing(reward);

        evolveConsumes.addAll(hero.getEvolve().reset());
        heroService.updateHero(hero);

        List<Hero> addHeroes = new ArrayList<>();
        evolveConsumes.forEach(heroConsume -> {
            CHeroType heroTypeConfig = heroTypeSysCache.getOrThrow(heroConsume.getType());
            for (int i = 0; i < heroConsume.getNum(); i++) {
                Hero hero1 = heroService.createHero(hero.getRid(), heroTypeConfig, heroConsume.getStar(), 0, 0);
                addHeroes.add(hero1);
            }
        });
        heroService.addHeros(addHeroes);
        eventBus.post(HeroGetEvent.of(hero.getRid(), addHeroes, GameEvent.HERO_EVOLVE_BACK));

        Rewards add = thingService.add(hero.getRid(), reward, GameEvent.HERO_EVOLVE_BACK, noticeType);
        return Rewards.ofHeros(add.getThingSet(), addHeroes);
    }

    public List<ObjectGMsg.PSBackpackData> builderRewardList(Rewards rewards) {
        List<ObjectGMsg.PSBackpackData> psBackpackDataList = new ArrayList<>();

        for (Hero hero : rewards.getHeroes()) {
            ObjectGMsg.PSBackpackData.Builder data = ObjectGMsg.PSBackpackData.newBuilder();
            data.setId(hero.getId());
            data.setType(hero.getType());
            data.setNum(1);
            data.setStar(hero.getStar());
            psBackpackDataList.add(data.build());
        }

        for (ImmutableThing thing : rewards.getThingSet().asList()) {
            CItem cItem = itemSysCache.getOrThrow(thing.getItem_type());
            if (cItem.getType() == ThingType.GOD_EQUIP.getType()
                    || cItem.getType() == ThingType.ITEM_HERO.getType()
                    || cItem.getType() == ThingType.HERO.getType()) {
                continue;
            }
            psBackpackDataList.add(PbUtil.buildReward(thing));
        }

        return psBackpackDataList;

    }

}
