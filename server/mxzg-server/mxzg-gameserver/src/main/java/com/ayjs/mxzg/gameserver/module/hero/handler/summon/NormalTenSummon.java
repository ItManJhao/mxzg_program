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

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

/**
 * @author YY
 *
 */
@Component
public class NormalTenSummon implements IHeroSummon {

	@Autowired
	private LotteryTypeSysCache lotteryTypeSysCache;
	@Autowired
	private LotteryWeightSysCache lotteryWeightSysCache;
	@Autowired
	private ThingService thingService;
	
	
	@Override
	public int summonType() {
		return HeroSummonType.NORMAL_TEN;
	}

	@Override
	public GameEvent heroGameEvent() {
		return GameEvent.HERO_LOTTERY_NORMAL_TEN;
	}

	public void summon(HeroSummon heroSummon, CLotteryPoint cLotteryPoint, List<ImmutableThing> heroThing) {
		thingService.cost(heroSummon.getRid(), cLotteryPoint.getNeed_item(), GameEvent.HERO_LOTTERY);
		
		summonLogic(heroSummon, cLotteryPoint, heroThing);
	}
	
	
	protected void summonLogic(HeroSummon heroSummon, CLotteryPoint cLotteryPoint, List<ImmutableThing> heroThing) {
		for(int i = 0; i < cLotteryPoint.getSummon_times(); i++) {
			// 当前抽奖类型各星级英雄的抽奖概率
	        List<CLotteryType> typeList = lotteryTypeSysCache.getByType(cLotteryPoint.getType());
	        CLotteryType randomType = DropUtil.randomDrop(typeList);
	        List<CLotteryWeight> randomList = lotteryWeightSysCache.getByStar(randomType.getStar());
	        
			// 普通抽使用普通的概率
			CLotteryWeight heroWeight = DropUtil.randomDrop(randomList, CLotteryWeight::getHero_type,
                    CLotteryWeight::getChance_normal);
			// 根据抽取到的星级找到时对应的英雄集Map,并从中抽取英雄ID
	        heroThing.add(ImmutableThing.of(heroWeight.getHero_type(), 1));
		}
	}
	
	public void testSummon() {
		Map<Integer, Integer> resultMap = new HashMap<>();
		for(int i = 0; i < 1000000; i++) {
			// 当前抽奖类型各星级英雄的抽奖概率
	        List<CLotteryType> typeList = lotteryTypeSysCache.getByType(1);
	        CLotteryType randomType = DropUtil.randomDrop(typeList);
	        List<CLotteryWeight> randomList = lotteryWeightSysCache.getByStar(randomType.getStar());
	        
			// 普通抽使用普通的概率
			CLotteryWeight heroWeight = DropUtil.randomDrop(randomList, CLotteryWeight::getHero_type,
                    CLotteryWeight::getChance_normal);
			Integer count = resultMap.get(heroWeight.getHero_type());
			if(count == null) {
				count = 0;
			}
			resultMap.put(heroWeight.getHero_type(), count + 1);
		}
		for(Entry<Integer, Integer> entry : resultMap.entrySet()) {
			System.out.println(entry);
		}
		
		System.out.println("====================================================");
		
		resultMap = new HashMap<>();
		
		for(int i = 0; i < 1000000; i++) {
			// 当前抽奖类型各星级英雄的抽奖概率
	        List<CLotteryType> typeList = lotteryTypeSysCache.getByType(2);
	        CLotteryType randomType = DropUtil.randomDrop(typeList);
	        List<CLotteryWeight> randomList = lotteryWeightSysCache.getByStar(randomType.getStar());
	        
			// 友情抽使用友情的概率
			CLotteryWeight heroWeight = DropUtil.randomDrop(randomList, CLotteryWeight::getHero_type,
                    CLotteryWeight::getChance_friend);
			Integer count = resultMap.get(heroWeight.getHero_type());
			if(count == null) {
				count = 0;
			}
			resultMap.put(heroWeight.getHero_type(), count + 1);
		}
		for(Entry<Integer, Integer> entry : resultMap.entrySet()) {
			System.out.println(entry);
		}
		System.out.println("====================================================");
		
		resultMap = new HashMap<>();
		
		for(int i = 0; i < 10000000; i++) {
			// 当前抽奖类型各星级英雄的抽奖概率
	        List<CLotteryType> typeList = lotteryTypeSysCache.getByType(3);
	        CLotteryType randomType = DropUtil.randomDrop(typeList);
	        List<CLotteryWeight> randomList = lotteryWeightSysCache.getByStar(randomType.getStar());
	        
			// 高级抽使用高级的概率
			CLotteryWeight heroWeight = DropUtil.randomDrop(randomList, CLotteryWeight::getHero_type,
                    CLotteryWeight::getChance_advance);
			Integer count = resultMap.get(heroWeight.getHero_type());
			if(count == null) {
				count = 0;
			}
			resultMap.put(heroWeight.getHero_type(), count + 1);
		}
		for(Entry<Integer, Integer> entry : resultMap.entrySet()) {
			System.out.println(entry);
		}
		
		
	}
}
