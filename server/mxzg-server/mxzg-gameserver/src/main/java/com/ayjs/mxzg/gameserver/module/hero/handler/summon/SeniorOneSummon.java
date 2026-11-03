/**
 *
 */
package com.ayjs.mxzg.gameserver.module.hero.handler.summon;

import com.ayjs.mxzg.common.util.DropUtil;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.cache.LotteryWeightSysCache;
import com.ayjs.mxzg.config.excel.cache.RewardGroupSysCache;
import com.ayjs.mxzg.config.excel.cache.ShopseniorticketSysCache;
import com.ayjs.mxzg.config.excel.cache.SystemSysCache;
import com.ayjs.mxzg.config.excel.constant.HeroConst;
import com.ayjs.mxzg.config.excel.entity.CLotteryPoint;
import com.ayjs.mxzg.config.excel.entity.CLotteryType;
import com.ayjs.mxzg.config.excel.entity.CLotteryWeight;
import com.ayjs.mxzg.config.excel.entity.CShopseniorticket;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.ItemType;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.hero.constant.HeroSummonType;
import com.ayjs.mxzg.gameserver.module.hero.domain.HeroSummon;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroSummonService;
import com.google.common.collect.ImmutableList;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Map;

/**
 * @author YY
 *
 */
@Component
public class SeniorOneSummon implements IHeroSummon {

	@Autowired
	private LotteryWeightSysCache lotteryWeightSysCache;
	@Autowired
	private RewardGroupSysCache rewardGroupSysCache;
	@Autowired
	private ThingService thingService;
	@Autowired
	private ShopseniorticketSysCache shopseniorticketSysCache;
	@Autowired
	private SystemSysCache systemSysCache;
    @Autowired
    private HeroSummonService heroSummonService;


	@Override
	public int summonType() {
		return HeroSummonType.SENIOR_ONE;
	}

	@Override
	public GameEvent heroGameEvent() {
		return GameEvent.HERO_LOTTERY_SENIOR_ONE;
	}

	public void summon(HeroSummon heroSummon, CLotteryPoint cLotteryPoint, List<ImmutableThing> heroThing) {
		int nowTime = TimeDateUtil.getCurrentTimeInt();
		if(nowTime < heroSummon.getSeniorFreeTime()) {
			if (thingService.enough(heroSummon.getRid(), cLotteryPoint.getNeed_item())) {
                thingService.cost(heroSummon.getRid(), cLotteryPoint.getNeed_item(), GameEvent.HERO_LOTTERY);
            } else {
            	// 高级单抽
                CShopseniorticket cShopseniorticket = shopseniorticketSysCache.getOrThrow(1);
                ImmutableThing gemCost = ImmutableThing.of(ItemType.IT_GEM, cShopseniorticket.getNeed_gem());
                thingService.cost(heroSummon.getRid(), gemCost, GameEvent.HERO_LOTTERY);
            }
		} else {
			heroSummon.setSeniorFreeTime(nowTime + cLotteryPoint.getFree_time());
		}

		if(heroSummon.getFirstSenior() == 0) {
			 // 第一次高级单抽
            heroSummon.setFirstSenior(heroSummon.getFirstSenior() + 1);

			if (systemSysCache.getFirstSeniorLottery() <= 0) {
				// 放置没配置固定奖励的情况
				// 新手指引第一次高级抽奖，随机3星
				// 当前抽奖类型各星级英雄的抽奖概率
				List<CLotteryWeight> cLotteryList = lotteryWeightSysCache.getByStar(3);
				CLotteryWeight cLotteryWeight = DropUtil.randomDrop(cLotteryList, CLotteryWeight::getHero_type,
						CLotteryWeight::getChance_advance);
				heroThing.add(ImmutableThing.of(cLotteryWeight.getHero_type(), 1));
			} else {

				// 新手指引第一次高级抽奖，必出10305021
				heroThing.add(ImmutableThing.of(systemSysCache.getFirstSeniorLottery(), 1));
			}

            heroSummon.setSeniorNum(heroSummon.getSeniorNum() + 1);

        } else if(heroSummon.getFirstSenior() == 1) {
			// 第二次高级单抽
            heroSummon.setFirstSenior(heroSummon.getFirstSenior() + 1);

            // 新手指引第二次高级抽奖，必出10105006
            heroThing.add(ImmutableThing.of(systemSysCache.getSecondSeniorLottery(), 1));

            heroSummon.setSeniorNum(heroSummon.getSeniorNum() + 1);
		} else {

            if((heroSummon.getSeniorNum() + 1) % HeroConst.ADV_SUMMON_T1_GUARANTEE_TIMES == 0) {
				//高级抽T1保底
				ImmutableList<ImmutableThing> rewardList = rewardGroupSysCache.getRewardGroupThing(HeroConst.ADV_SUMMON_T1_GUARANTEE_REWARD_GROUP);
				for(ImmutableThing thing : rewardList) {
					heroThing.add(ImmutableThing.of(thing.getItem_type(), thing.getItem_num()));
				}
			} else {
				// 当前抽奖类型各星级英雄的抽奖概率
//		        List<CLotteryType> typeList = lotteryTypeSysCache.getByType(cLotteryPoint.getType());
                Map<Integer, Integer> seniorLowerUpper = heroSummon.getSeniorLowerUpper();
                List<CLotteryType> typeList = heroSummonService.getByTypeAndStarLimit(cLotteryPoint.getType(), seniorLowerUpper);
                CLotteryType randomType = DropUtil.randomDrop(typeList);
		        heroSummon.setSummonNum(heroSummon.getSummonNum() + 1);

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

		        if(heroSummon.getSummonNum() >= HeroConst.ADV_SUMMON_GUARANTEE_TIME && star < 5) {
		        	ImmutableList<ImmutableThing> rewardList = rewardGroupSysCache.getRewardGroupThing(HeroConst.ADV_SUMMON_GUARANTEE_REWARD_GROUP);
		        	for(ImmutableThing thing : rewardList) {
		        		heroThing.add(ImmutableThing.of(thing.getItem_type(), 1));
		        	}
		        	heroSummon.setSummonNum(0);
					seniorLowerUpper.put(5, 0);
		        } else {
		        	List<CLotteryWeight> randomList = lotteryWeightSysCache.getByStar(star);

                    // 普通抽使用普通的概率
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
