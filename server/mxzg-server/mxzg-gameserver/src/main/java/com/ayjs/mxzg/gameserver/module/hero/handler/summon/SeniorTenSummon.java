/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.hero.handler.summon;

import com.ayjs.mxzg.common.util.DropUtil;
import com.ayjs.mxzg.config.excel.cache.LotteryWeightSysCache;
import com.ayjs.mxzg.config.excel.cache.RewardGroupSysCache;
import com.ayjs.mxzg.config.excel.constant.HeroConst;
import com.ayjs.mxzg.config.excel.entity.CLotteryPoint;
import com.ayjs.mxzg.config.excel.entity.CLotteryType;
import com.ayjs.mxzg.config.excel.entity.CLotteryWeight;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.backpack.service.processor.ItemProcessor;
import com.ayjs.mxzg.gameserver.module.hero.constant.HeroSummonType;
import com.ayjs.mxzg.gameserver.module.hero.domain.HeroSummon;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroSummonService;
import com.google.common.collect.ImmutableList;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * @author YY
 *
 */
@Component
public class SeniorTenSummon implements IHeroSummon {

	@Autowired
	private LotteryWeightSysCache lotteryWeightSysCache;
	@Autowired
	private RewardGroupSysCache rewardGroupSysCache;
	@Autowired
	private ThingService thingService;
	@Autowired
	private ItemProcessor itemProcessor;
    @Autowired
    private HeroSummonService heroSummonService;
	
	@Override
	public int summonType() {
		return HeroSummonType.SENIOR_TEN;
	}

	@Override
	public GameEvent heroGameEvent() {
		return GameEvent.HERO_LOTTERY_SENIOR_TEN;
	}

	public void summon(HeroSummon heroSummon, CLotteryPoint cLotteryPoint, List<ImmutableThing> heroThing) {
		
		List<ImmutableThing> costList = new ArrayList<>();
		
		ImmutableThing costTicket = cLotteryPoint.getNeed_item().get(0);
		if (thingService.enough(heroSummon.getRid(), cLotteryPoint.getNeed_item())) {
			costList.add(costTicket);
        } else {
        	// 高级10连
        	long hasCount = itemProcessor.getCount(heroSummon.getRid(), costTicket.getItem_type());
        	long fixCount = costTicket.getItem_num() - hasCount;
        	
        	List<ImmutableThing> gemCost = ImmutableThingUtil.multiplyThing(HeroConst.ADV_SUMMON_10_FIXED_PRIZE, fixCount);
        	
        	if(hasCount > 0) {
        		ImmutableThing costItem = ImmutableThing.of(costTicket.getItem_type(), hasCount);
        		costList.add(costItem);
        	}
        	costList.addAll(gemCost);
        }
		thingService.cost(heroSummon.getRid(), costList, GameEvent.HERO_LOTTERY);
		
		if (heroSummon.getGuaranteeNum() == 0) {
            //新手初次十连
            ImmutableList<ImmutableThing> rewardList = rewardGroupSysCache.getRewardGroupThing(HeroConst.FIRST_ADV_SUMMON_GUARANTEE_REWARD_GROUP);
			for(ImmutableThing thing : rewardList) {
				heroThing.add(ImmutableThing.of(thing.getItem_type(), thing.getItem_num()));
			}
        }
        heroSummon.setGuaranteeNum(heroSummon.getGuaranteeNum() + 1);
        
        // 当前抽奖类型各星级英雄的抽奖概率
        boolean hasStar4 = false;

        
        int rollCount = cLotteryPoint.getSummon_times() - heroThing.size();
        for(int i = 0; i < rollCount; i++) {
            if((heroSummon.getSeniorNum() + 1) % HeroConst.ADV_SUMMON_T1_GUARANTEE_TIMES == 0) {
				//高级抽T1保底
				ImmutableList<ImmutableThing> rewardList = rewardGroupSysCache.getRewardGroupThing(HeroConst.ADV_SUMMON_T1_GUARANTEE_REWARD_GROUP);
				for(ImmutableThing thing : rewardList) {
					heroThing.add(ImmutableThing.of(thing.getItem_type(), thing.getItem_num()));
				}
			} else {
                Map<Integer, Integer> seniorLowerUpper = heroSummon.getSeniorLowerUpper();
                List<CLotteryType> typeList = heroSummonService.getByTypeAndStarLimit(cLotteryPoint.getType(), seniorLowerUpper);
				CLotteryType randomType = DropUtil.randomDrop(typeList);
				heroSummon.setSummonNum(heroSummon.getSummonNum() + 1);
	            // 获取星级
	            int star = randomType.getStar();
	            if(star >= 5) {
	            	//抽到5星便重置保底
	            	heroSummon.setSummonNum(0);
	            }
                if (star == 5) {
                    seniorLowerUpper.put(star, 0);
                    seniorLowerUpper.compute(4, (k, v) -> (v == null) ? 1 : v + 1);
                } else if (star == 4) {
                    seniorLowerUpper.put(star, 0);
                    seniorLowerUpper.compute(5, (k, v) -> (v == null) ? 1 : v + 1);
                } else {
                    seniorLowerUpper.compute(4, (k, v) -> (v == null) ? 1 : v + 1);
                    seniorLowerUpper.compute(5, (k, v) -> (v == null) ? 1 : v + 1);
                }

	            if (heroSummon.getSummonNum() >= HeroConst.ADV_SUMMON_GUARANTEE_TIME && star < 5) {
                    //高级10连抽保底
                    ImmutableList<ImmutableThing> rewardList = rewardGroupSysCache.getRewardGroupThing(HeroConst.ADV_SUMMON_GUARANTEE_REWARD_GROUP);
		        	for(ImmutableThing thing : rewardList) {
		        		heroThing.add(ImmutableThing.of(thing.getItem_type(), 1));
		        	}
		        	heroSummon.setSummonNum(0);
		        	hasStar4 = true;
					seniorLowerUpper.put(5, 0);
                } else {
                	if(star >= 4) {
    	            	hasStar4 = true;
    	            }
                	//10连最后一次都没有出过高于4星的英雄，则给一个四星
    	            if(i == rollCount - 1 && !hasStar4) {
    	            	star = 4;
						seniorLowerUpper.put(4, 0);
    	            }
    	            List<CLotteryWeight> randomList = lotteryWeightSysCache.getByStar(star);
                    CLotteryWeight heroWeight = DropUtil.randomDrop(randomList, CLotteryWeight::getHero_type,
                                    CLotteryWeight::getChance_advance);
                    // 根据抽取到的星级找到时对应的英雄集Map，并从中抽取英雄ID
                    heroThing.add(ImmutableThing.of(heroWeight.getHero_type(), 1));
                }
			}
            heroSummon.setSeniorNum(heroSummon.getSeniorNum() + 1);
        }
	}
}
