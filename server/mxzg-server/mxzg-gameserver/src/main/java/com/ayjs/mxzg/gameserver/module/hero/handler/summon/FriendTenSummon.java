/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.hero.handler.summon;

import com.ayjs.mxzg.common.util.DropUtil;
import com.ayjs.mxzg.config.excel.cache.LotteryTypeSysCache;
import com.ayjs.mxzg.config.excel.cache.LotteryWeightSysCache;
import com.ayjs.mxzg.config.excel.entity.CLotteryPoint;
import com.ayjs.mxzg.config.excel.entity.CLotteryType;
import com.ayjs.mxzg.config.excel.entity.CLotteryWeight;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.hero.constant.HeroSummonType;
import com.ayjs.mxzg.gameserver.module.hero.domain.HeroSummon;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.List;

/**
 * @author YY
 *
 */
@Component
public class FriendTenSummon implements IHeroSummon {

	@Autowired
	private LotteryTypeSysCache lotteryTypeSysCache;
	@Autowired
	private LotteryWeightSysCache lotteryWeightSysCache;
	@Autowired
	private ThingService thingService;
	
	@Override
	public int summonType() {
		return HeroSummonType.FRIEND_TEN;
	}

	@Override
	public GameEvent heroGameEvent() {
		return GameEvent.HERO_LOTTERY_FRIEND_TEN;
	}

	public void summon(HeroSummon heroSummon, CLotteryPoint cLotteryPoint, List<ImmutableThing> heroThing) {
		
		thingService.cost(heroSummon.getRid(), cLotteryPoint.getNeed_item(), GameEvent.HERO_LOTTERY);
		
		for(int i = 0; i < cLotteryPoint.getSummon_times(); i++) {
			// 当前抽奖类型各星级英雄的抽奖概率
	        List<CLotteryType> typeList = lotteryTypeSysCache.getByType(cLotteryPoint.getType());
	        CLotteryType randomType = DropUtil.randomDrop(typeList);
	        List<CLotteryWeight> randomList = lotteryWeightSysCache.getByStar(randomType.getStar());
	        
			// 友情抽使用友情的概率
			CLotteryWeight heroWeight = DropUtil.randomDrop(randomList, CLotteryWeight::getHero_type,
                    CLotteryWeight::getChance_friend);
			// 根据抽取到的星级找到时对应的英雄集Map,并从中抽取英雄ID
	        heroThing.add(ImmutableThing.of(heroWeight.getHero_type(), 1));
		}
	}
}
