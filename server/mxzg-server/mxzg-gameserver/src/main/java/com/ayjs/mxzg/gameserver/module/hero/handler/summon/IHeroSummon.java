/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.hero.handler.summon;

import com.ayjs.mxzg.config.excel.entity.CLotteryPoint;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.module.hero.domain.HeroSummon;

import java.util.List;

/**
 * @author YY
 *
 */
public interface IHeroSummon {

	int summonType();

	/**
	 * 英雄事件
	 * @return
	 */
	GameEvent heroGameEvent();
	
	void summon(HeroSummon heroSummon, CLotteryPoint cLotteryPoint, List<ImmutableThing> heroThing);
	
	default boolean isCanSummon() {
		return true;
	}
	//召唤完成后的处理
	default void handleAfterSummon(PlayerContext playerContext) {}
}
