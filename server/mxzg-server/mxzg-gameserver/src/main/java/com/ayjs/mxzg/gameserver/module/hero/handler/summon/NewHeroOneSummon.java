/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.hero.handler.summon;

import com.ayjs.mxzg.common.util.DropUtil;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.cache.LotteryWeightSysCache;
import com.ayjs.mxzg.config.excel.cache.RewardGroupSysCache;
import com.ayjs.mxzg.config.excel.cache.ShopseniorticketSysCache;
import com.ayjs.mxzg.config.excel.constant.HeroConst;
import com.ayjs.mxzg.config.excel.entity.CLotteryPoint;
import com.ayjs.mxzg.config.excel.entity.CLotteryType;
import com.ayjs.mxzg.config.excel.entity.CLotteryWeight;
import com.ayjs.mxzg.config.excel.entity.CShopseniorticket;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.ItemType;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.hero.constant.HeroSummonType;
import com.ayjs.mxzg.gameserver.module.hero.domain.HeroSummon;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroSummonService;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion065HeroRolling;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.Promotion065HeroRollingService;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.PromotionControlService;
import com.ayjs.mxzg.protocol.HeroRollingGMsg.GResHeroRollingSummon;
import com.google.common.collect.ImmutableList;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Map;

/**
 * @author YY
 * 新英雄活动单抽
 */
@Component
public class NewHeroOneSummon implements IHeroSummon {

	@Autowired
	private Promotion065HeroRollingService promotion065HeroRollingService;
	@Autowired
	private PromotionControlService promotionControlService;
	@Autowired
	private HeroSummonService heroSummonService;
	@Autowired
	private LotteryWeightSysCache lotteryWeightSysCache;
	@Autowired
	private RewardGroupSysCache rewardGroupSysCache;
	@Autowired
	private ThingService thingService;
	@Autowired
	private ShopseniorticketSysCache shopseniorticketSysCache;
	
	@Override
	public int summonType() {
		return HeroSummonType.NEW_HERO_ONE;
	}

	@Override
	public GameEvent heroGameEvent() {
		return GameEvent.HERO_LOTTERY_NEW_HERO_ONE;
	}

	@Override
	public void summon(HeroSummon heroSummon, CLotteryPoint cLotteryPoint, List<ImmutableThing> heroThing) {
		
		Promotion065HeroRolling promotionInfo = promotion065HeroRollingService.getPromotionInfo(heroSummon.getRid());
		
		int nowTime = TimeDateUtil.getCurrentTimeInt();
		if(promotionInfo.getFreeTime() <= nowTime) {
			//免费单抽
			promotionInfo.setFreeTime(nowTime + cLotteryPoint.getFree_time());
		} else {
			if (thingService.enough(heroSummon.getRid(), cLotteryPoint.getNeed_item())) {
	            thingService.cost(heroSummon.getRid(), cLotteryPoint.getNeed_item(), GameEvent.HERO_NEW_ROLLING);
	        } else {
	        	// 新英雄单抽
	            CShopseniorticket cShopseniorticket = shopseniorticketSysCache.getOrThrow(2);
	            ImmutableThing gemCost = ImmutableThing.of(ItemType.IT_GEM, cShopseniorticket.getNeed_gem());
	            thingService.cost(heroSummon.getRid(), gemCost, GameEvent.HERO_NEW_ROLLING);
	        }
		}
		
		if(!isNewHeroShowOut(promotionInfo, heroThing)) {
			if(promotionInfo.getTriggerNum() > HeroConst.NHA_MUSTOUT_FIVESTAR_TIMES) {
				ImmutableList<ImmutableThing> rewardList = rewardGroupSysCache.getRewardGroupThing(HeroConst.NHA_MUSTOUT_FIVESTAR_GROUP);
				for(ImmutableThing thing : rewardList) {
					heroThing.add(ImmutableThing.of(thing.getItem_type(), thing.getItem_num()));
				}
				promotionInfo.setTriggerNum(0);
			} else {
				promotionInfo.setTriggerNum(promotionInfo.getTriggerNum() + 1);
				
				Map<Integer, Integer> seniorLowerUpper = heroSummon.getSeniorLowerUpper();
	            List<CLotteryType> typeList = heroSummonService.getByTypeAndStarLimit(cLotteryPoint.getType(), seniorLowerUpper);
	            CLotteryType randomType = DropUtil.randomDrop(typeList);
				
	            int star = randomType.getStar();
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
	            
		        List<CLotteryWeight> randomList = lotteryWeightSysCache.getByStar(star);

	            // 普通抽使用普通的概率
				CLotteryWeight heroWeight = DropUtil.randomDrop(randomList, CLotteryWeight::getHero_type,
	                    CLotteryWeight::getChance_rolling);
				// 根据抽取到的星级找到时对应的英雄集Map，并从中抽取英雄ID
		        heroThing.add(ImmutableThing.of(heroWeight.getHero_type(), 1));
			}
			promotionInfo.setSummonNum(promotionInfo.getSummonNum() + 1);
		}
		promotionInfo.setHisNum(promotionInfo.getHisNum() + 1);
		promotion065HeroRollingService.updatePromotion(promotionInfo);
	}

	@Override
	public boolean isCanSummon() {
		return promotionControlService.isPromotionRunning(PromotionType.HERO_ROLLING);
	}

	@Override
	public void handleAfterSummon(PlayerContext playerContext) {
		Promotion065HeroRolling promotionInfo = promotion065HeroRollingService.getPromotionInfo(playerContext.getId());
		
		int mustout = HeroConst.NHA_NEWHERO_MUSTOUT[promotionInfo.getSummonIndex()];
		GResHeroRollingSummon.Builder builder = GResHeroRollingSummon.newBuilder();
		builder.setSummonNum(promotionInfo.getHisNum());
		builder.setFreeTime(promotionInfo.getFreeTime());
		builder.setHeroOutNum(mustout - promotionInfo.getSummonNum());
		playerContext.write(CmdCode._13273, builder.build());
	}
	
	/**
	 * 是否出新英雄
	 * @param promotionInfo
	 * @param heroThing
	 * @return
	 */
	protected boolean isNewHeroShowOut(Promotion065HeroRolling promotionInfo, List<ImmutableThing> heroThing) {
		int newHeroMustout = HeroConst.NHA_NEWHERO_MUSTOUT[promotionInfo.getSummonIndex()];
		if((promotionInfo.getSummonNum() + 1) >= newHeroMustout) {
			//必出新英雄
			ImmutableList<ImmutableThing> rewardList = rewardGroupSysCache.getRewardGroupThing(HeroConst.NHA_NEWHERO_GROUP);
			for(ImmutableThing thing : rewardList) {
				heroThing.add(ImmutableThing.of(thing.getItem_type(), thing.getItem_num()));
			}
			promotionInfo.setSummonNum(0);
			
			int newIndex = promotionInfo.getSummonIndex() + 1;
			if(newIndex >= HeroConst.NHA_NEWHERO_MUSTOUT.length) {
				newIndex = HeroConst.NHA_NEWHERO_MUSTOUT.length - 1;
			}
			promotionInfo.setSummonIndex(newIndex);
			return true;
		} else {
			return false;
		}
	}
}
