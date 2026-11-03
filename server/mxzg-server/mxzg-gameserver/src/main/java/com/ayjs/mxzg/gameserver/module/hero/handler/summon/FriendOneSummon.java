/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.hero.handler.summon;

import com.ayjs.mxzg.config.excel.entity.CLotteryPoint;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
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
public class FriendOneSummon implements IHeroSummon {

	@Autowired
	private FriendTenSummon friendTenSummon;
	
	public void summon(HeroSummon heroSummon, CLotteryPoint cLotteryPoint, List<ImmutableThing> heroThing) {
		friendTenSummon.summon(heroSummon, cLotteryPoint, heroThing);
	}

	@Override
	public int summonType() {
		return HeroSummonType.FRIEND_ONE;
	}

	@Override
	public GameEvent heroGameEvent() {
		return GameEvent.HERO_LOTTERY_FRIEND_ONE;
	}
}
