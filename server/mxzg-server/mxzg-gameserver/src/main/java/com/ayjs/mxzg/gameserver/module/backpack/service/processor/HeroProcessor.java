/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.backpack.service.processor;

import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.config.excel.cache.HeroTypeSysCache;
import com.ayjs.mxzg.config.excel.entity.CHeroType;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.gameserver.module.backpack.service.Rewards;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingProcessor;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingSet;
import com.ayjs.mxzg.gameserver.module.hero.domain.Hero;
import com.ayjs.mxzg.gameserver.module.hero.event.HeroGetEvent;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroService;
import com.ayjs.mxzg.template.constant.ErrorCode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;


/**
 * @author YY
 *
 */
@Component
public class HeroProcessor implements ThingProcessor {

	@Autowired
	private HeroTypeSysCache heroTypeSysCache;
	@Autowired
	private HeroService heroService;
	@Autowired
	private EventBus eventBus;

	@Override
	public ThingType thingType() {
		return ThingType.HERO;
	}

	@Override
	public ErrorCode notEnoughCode() {
		throw new UnsupportedOperationException("不能扣除英雄");
	}

	@Override
	public long getCount(long rid, int thingType) {
		throw new UnsupportedOperationException("不能扣除英雄");
	}

	@Override
	public Rewards add(long rid, ThingSet thingSet, GameEvent gameEvent) {

		List<Hero> heroList = new ArrayList<>();
		for (ImmutableThing reward : thingSet.asList()) {
			CHeroType cHeroType = heroTypeSysCache.getOrThrow(reward.getItem_type());
			
			for (int i = 0; i < reward.getItem_num(); i++) {
				Hero hero = heroService.createHero(rid, cHeroType);
				heroList.add(hero);
			}
		}
		heroService.addHeros(heroList);
		
		eventBus.post(HeroGetEvent.of(rid, heroList, gameEvent));
		return Rewards.ofHeros(thingSet, heroList);
	}

	@Override
	public ThingSet prepareCost(long rid, ThingSet thingSet, GameEvent gameEvent) {
		throw new UnsupportedOperationException("不能扣除英雄");
	}

	@Override
	public void cost(long rid, ThingSet thingSet, GameEvent gameEvent) {
		throw new UnsupportedOperationException("不能扣除英雄");
	}

}
