/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.promotionNew.handler;

import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.config.excel.cache.promotion.Promotion026SpeedfightSysCache;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion026SpeedFight;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion026SpeedFight;
import com.ayjs.mxzg.gameserver.module.promotionNew.rank.SpeedFightRankService;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.Promotion026SpeedFightService;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.PromotionControlService;
import com.ayjs.mxzg.protocol.ObjectGMsg.PSMapData;
import com.ayjs.mxzg.protocol.Promotion026GMsg.GReqGetSpeedFightReward;
import com.ayjs.mxzg.protocol.Promotion026GMsg.GReqScanSpeedFightRank;
import com.ayjs.mxzg.protocol.Promotion026GMsg.GReqSpeedFightCountData;
import com.ayjs.mxzg.protocol.Promotion026GMsg.GResGetSpeedFightReward;
import com.ayjs.mxzg.protocol.Promotion026GMsg.GResScanSpeedFightRank;
import com.ayjs.mxzg.protocol.Promotion026GMsg.GResSpeedFightCountData;
import com.ayjs.mxzg.template.constant.ErrorCode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

/**
 * @author YY
 *
 */
@Controller
public class Promotion026SpeedFightHandler extends ProtocolHandler {
	
	@Autowired
	private Promotion026SpeedFightService promotion026SpeedFightService;
	@Autowired
	private PromotionControlService promotionControlService;
	@Autowired
    private ThingService thingService;
	@Autowired
	private Promotion026SpeedfightSysCache promotion026SpeedfightSysCache;
	@Autowired
	private SpeedFightRankService speedFightRankService;

	/**
	 * 旧协议13115
	 * @param playerContext
	 * @param msg
	 */
	@CMD(id = CmdCode._13371)
	public void scanInfo(PlayerContext playerContext, GReqSpeedFightCountData msg) {
		Promotion026SpeedFight promotion = promotion026SpeedFightService.getPromotionInfo(playerContext.getId());
		
		GResSpeedFightCountData.Builder builder = GResSpeedFightCountData.newBuilder();
		builder.setCount(promotion.getRankCount());
		for(int idx : promotion.getTakeRewards()) {
			//东龙要求的keyvalue
			PSMapData.Builder ele = PSMapData.newBuilder();
			ele.setKey(idx);
			ele.setValue(1);
			builder.addList(ele.build());
		}
		playerContext.write(CmdCode._13371, builder.build());
	}

	/**
	 * 旧协议13117
	 * @param playerContext
	 * @param msg
	 */
	@CMD(id = CmdCode._13372)
	public void getReward(PlayerContext playerContext, GReqGetSpeedFightReward msg) {
		if(!promotionControlService.isPromotionRunning(PromotionType.SU_ZHAN_ZHI_WANG)) {
			//不在活动期间
			playerContext.writeError(ErrorCode.PROMOTION_NOT_RUNNING);
			return;
		}
		Promotion026SpeedFight promotion = promotion026SpeedFightService.getPromotionInfo(playerContext.getId());
		
		CPromotion026SpeedFight cSpeedFight = promotion026SpeedfightSysCache.getByTurnsIdx(promotion.getTurns(), msg.getIdx());
		if(cSpeedFight == null) {
			//该奖励不属于当前活动
			playerContext.writeError(ErrorCode.PROMOTION_CONFIG_MISS);
			return;
		}
		if(promotion.getTakeRewards().contains(cSpeedFight.getIdx())) {
			//已经领取该奖励
			playerContext.writeError(ErrorCode.PROMOTION_TOOK_REWARD);
			return;
		}
		if(promotion.getRankCount() < cSpeedFight.getSpeed_fight_times()) {
			//还没有达到领取奖励的要求
			playerContext.writeError(ErrorCode.PROMOTION_CANT_TAKE);
			return;
		}
		promotion.getTakeRewards().add(cSpeedFight.getIdx());
		promotion026SpeedFightService.updatePromotion(promotion);

        thingService.add(playerContext.getId(), cSpeedFight.getReward(), GameEvent.SPEED_FIGHT_GIFT);
		
		GResGetSpeedFightReward.Builder builder = GResGetSpeedFightReward.newBuilder();
		builder.setIdx(cSpeedFight.getIdx());
		playerContext.write(CmdCode._13372, builder.build());
	}

	/**
	 * 旧协议13116
	 * @param playerContext
	 * @param msg
	 */
	@CMD(id = CmdCode._13373)
	public void scanRank(PlayerContext playerContext, GReqScanSpeedFightRank msg) {
		
		int rank = speedFightRankService.getRank(playerContext.getId());
		
		GResScanSpeedFightRank.Builder builder = GResScanSpeedFightRank.newBuilder();
		builder.setMyRank(rank);
		builder.addAllList(speedFightRankService.showRanks(50));
		playerContext.write(CmdCode._13373, builder.build());
	}
	
}
