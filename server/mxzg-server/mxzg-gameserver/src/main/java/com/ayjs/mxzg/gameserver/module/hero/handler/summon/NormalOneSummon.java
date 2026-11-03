/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.hero.handler.summon;

import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.cache.SystemSysCache;
import com.ayjs.mxzg.config.excel.entity.CLotteryPoint;
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
public class NormalOneSummon implements IHeroSummon {

	@Autowired
	private NormalTenSummon normalTenSummon;
	@Autowired
	private ThingService thingService;
	@Autowired
	private SystemSysCache systemSysCache;
	
	@Override
	public int summonType() {
		return HeroSummonType.NORMAL_ONE;
	}

	@Override
	public GameEvent heroGameEvent() {
		return GameEvent.HERO_LOTTERY_NORMAL_ONE;
	}

	public void summon(HeroSummon heroSummon, CLotteryPoint cLotteryPoint, List<ImmutableThing> heroThing) {
		
		int nowTime = TimeDateUtil.getCurrentTimeInt();
		if(nowTime < heroSummon.getFreeTime()) {
			thingService.cost(heroSummon.getRid(), cLotteryPoint.getNeed_item(), GameEvent.HERO_LOTTERY);
		} else {
			heroSummon.setFreeTime(nowTime + cLotteryPoint.getFree_time());
		}
		
		if(heroSummon.getFirstNormal() == 0) {
			 // 第一次普通抽
            heroSummon.setFirstNormal(1);
            // 新手指引普通抽奖，必出10204004
            heroThing.add(ImmutableThing.of(systemSysCache.getFirstOrdinaryLottery(), 1));
		} else {
			normalTenSummon.summonLogic(heroSummon, cLotteryPoint, heroThing);
        }
	}
}
