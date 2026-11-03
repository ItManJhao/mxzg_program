/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.promotionNew.handler;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.config.excel.constant.HeroConst;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion065HeroRolling;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.Promotion065HeroRollingService;
import com.ayjs.mxzg.gameserver.web.activity.config.Promotion065HeroRollingConfig;
import com.ayjs.mxzg.protocol.HeroRollingGMsg.GReqHeroRollingData;
import com.ayjs.mxzg.protocol.HeroRollingGMsg.GReqHeroRollingReward;
import com.ayjs.mxzg.protocol.HeroRollingGMsg.GResHeroRollingData;
import com.ayjs.mxzg.protocol.HeroRollingGMsg.GResHeroRollingReward;
import com.ayjs.mxzg.template.constant.ErrorCode;

/**
 * @author YY
 *
 */
@Controller
public class Promotion065HeroRollingHandler extends ProtocolHandler {

	@Autowired
	private Promotion065HeroRollingService promotion065HeroRollingService;
	@Autowired
	private ThingService thingService;
	
	@CMD(id = CmdCode._13271)
	public void scanInfo(PlayerContext playerContext, GReqHeroRollingData msg) {
		Promotion065HeroRolling promotionInfo = promotion065HeroRollingService.getPromotionInfo(playerContext.getId());
		
		GResHeroRollingData.Builder builder = GResHeroRollingData.newBuilder();
		
		int mustout = HeroConst.NHA_NEWHERO_MUSTOUT[promotionInfo.getSummonIndex()];
		builder.setSummonNum(promotionInfo.getHisNum());
		builder.addAllRewards(promotionInfo.getRewards());
		builder.setFreeTime(promotionInfo.getFreeTime());
		builder.setHeroOutNum(mustout - promotionInfo.getSummonNum());
		playerContext.write(CmdCode._13271, builder.build());
	}
	
	//TODO 抽卡逻辑在英雄召唤功能里HeroHandler.heroSummon
	
	//领取奖励
	@CMD(id = CmdCode._13272)
	public void getSummonReward(PlayerContext playerContext, GReqHeroRollingReward msg) {
		Promotion065HeroRollingConfig cPromotion = promotion065HeroRollingService.getReward(msg.getIdx());
		
		Promotion065HeroRolling promotionInfo = promotion065HeroRollingService.getPromotionInfo(playerContext.getId());
		Asserts.isTrue(promotionInfo.getHisNum() >= cPromotion.getTask_count(), ErrorCode.NHA_COUNT_LOW.getValue(), "还没有达到领取该奖励的要求");
		Asserts.isTrue(!promotionInfo.getRewards().contains(cPromotion.getIdx()), ErrorCode.NHA_TOOK.getValue(), "已经领取该奖励");
		
		promotionInfo.getRewards().add(cPromotion.getIdx());
		promotion065HeroRollingService.updatePromotion(promotionInfo);
		
		thingService.add(playerContext.getId(), cPromotion.getRewardThings(), GameEvent.PROMOTION_NHA_REWARD);
		
		GResHeroRollingReward.Builder builder = GResHeroRollingReward.newBuilder();
		builder.setIdx(msg.getIdx());
		playerContext.write(CmdCode._13272, builder.build());
	}
	
}
