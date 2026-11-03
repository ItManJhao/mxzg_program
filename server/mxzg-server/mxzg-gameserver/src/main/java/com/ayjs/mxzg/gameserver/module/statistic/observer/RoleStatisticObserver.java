package com.ayjs.mxzg.gameserver.module.statistic.observer;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.gameserver.module.backpack.event.ThingAddEvent;
import com.ayjs.mxzg.gameserver.module.hero.event.HeroGetEvent;
import com.ayjs.mxzg.gameserver.module.statistic.constant.StatisticItem;
import com.ayjs.mxzg.gameserver.module.statistic.service.RoleStatisticService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.HashSet;
import java.util.Set;

@Component
@Observer
public class RoleStatisticObserver {

    @Autowired
    private RoleStatisticService roleStatisticService;

    private final static Set<GameEvent> eventSet = new HashSet<>();

    static {
        eventSet.add(GameEvent.EQUIP_ALL_OFF);//装备一键脱下
        eventSet.add(GameEvent.EQUIP_OFF);//装备脱下
        eventSet.add(GameEvent.EQUIP_ALL_WEAR);//装备一键穿戴
        eventSet.add(GameEvent.EQUIP_CHANGE);//装备替换
        eventSet.add(GameEvent.HERO_REBORN);//英雄重生
        eventSet.add(GameEvent.HERO_COME_BACK);//英雄回退
        eventSet.add(GameEvent.HERO_SWITCH);//英雄置换
    }

    @Subscribe(async = Subscribe.AsyncType.AsyncLog)
    public void onEvent(ThingAddEvent event) {
        if (eventSet.contains(event.getGameEvent())) {
            return;
        }

        long rid = event.getRid();
        event.getRewards().getThingSet().asList().forEach(immutableThing -> {
            if (StatisticItem.contain(immutableThing.getItem_type())) {
                roleStatisticService.update(rid, immutableThing.getItem_type(), immutableThing.getItem_num());
            }
        });
    }

    @Subscribe(async = Subscribe.AsyncType.AsyncLog)
    public void onEvent(HeroGetEvent event) {
        if (eventSet.contains(event.getGameEvent())) {
            return;
        }

        long rid = event.getRid();
        event.getHeros().forEach(hero -> {
            roleStatisticService.updateHero(rid, hero.getStar());
        });
    }
}
