/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.promotionNew.handler;

import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.config.excel.cache.promotion.Promotion028TavernWeeklySysCache;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion028TavernWeekly;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion028TavernInfo;
import com.ayjs.mxzg.gameserver.module.promotionNew.rank.TavernRankService;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.Promotion028TavernInfoService;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.PromotionControlService;
import com.ayjs.mxzg.protocol.ObjectGMsg.PSMapData;
import com.ayjs.mxzg.protocol.Promotion028GMsg.GReqGetTavernReward;
import com.ayjs.mxzg.protocol.Promotion028GMsg.GReqScanTavernRank;
import com.ayjs.mxzg.protocol.Promotion028GMsg.GReqTavernCountData;
import com.ayjs.mxzg.protocol.Promotion028GMsg.GResGetTavernReward;
import com.ayjs.mxzg.protocol.Promotion028GMsg.GResScanTavernRank;
import com.ayjs.mxzg.protocol.Promotion028GMsg.GResTavernCountData;
import com.ayjs.mxzg.template.constant.ErrorCode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

/**
 * @author YY
 *
 */
@Controller
public class Promotion028TavernInfoHandler extends ProtocolHandler {

	@Autowired
	private Promotion028TavernInfoService promotion028TavernInfoService;
	@Autowired
	private PromotionControlService promotionControlService;
	@Autowired
    private ThingService thingService;
	@Autowired
	private Promotion028TavernWeeklySysCache promotion028TavernWeeklySysCache;
	@Autowired
	private TavernRankService tavernRankService;


	@CMD(id = CmdCode._13391)
	public void scanInfo(PlayerContext playerContext, GReqTavernCountData msg) {
		Promotion028TavernInfo promotion = promotion028TavernInfoService.getPromotionInfo(playerContext.getId());
		
		GResTavernCountData.Builder builder = GResTavernCountData.newBuilder();
		builder.setCount(promotion.getRankCount());
		for(int idx : promotion.getTakeRewards()) {
			//东龙要求的keyvalue
			PSMapData.Builder ele = PSMapData.newBuilder();
			ele.setKey(idx);
			ele.setValue(1);
			builder.addList(ele.build());
		}
		playerContext.write(CmdCode._13391, builder.build());
	}

	@CMD(id = CmdCode._13392)
	public void getReward(PlayerContext playerContext, GReqGetTavernReward msg) {
		if(!promotionControlService.isPromotionRunning(PromotionType.JIU_GUAN_CHANG_KE)) {
			//不在活动期间
			playerContext.writeError(ErrorCode.PROMOTION_NOT_RUNNING);
			return;
		}
		Promotion028TavernInfo promotion = promotion028TavernInfoService.getPromotionInfo(playerContext.getId());
		
		CPromotion028TavernWeekly cConfig = promotion028TavernWeeklySysCache.getByTurnsIdx(promotion.getTurns(), msg.getIdx());
		if(cConfig == null) {
			//该奖励不属于当前活动
			playerContext.writeError(ErrorCode.PROMOTION_CONFIG_MISS);
			return;
		}
		if(promotion.getTakeRewards().contains(cConfig.getIdx())) {
			//已经领取该奖励
			playerContext.writeError(ErrorCode.PROMOTION_TOOK_REWARD);
			return;
		}
		if(promotion.getRankCount() < cConfig.getTavern_finish_times()) {
			//还没有达到领取奖励的要求
			playerContext.writeError(ErrorCode.PROMOTION_CANT_TAKE);
			return;
		}
		promotion.getTakeRewards().add(cConfig.getIdx());
		promotion028TavernInfoService.updatePromotion(promotion);

        thingService.add(playerContext.getId(), cConfig.getReward(), GameEvent.TAVERN_WEEKLY_GIFT);
		
		GResGetTavernReward.Builder builder = GResGetTavernReward.newBuilder();
		builder.setIdx(cConfig.getIdx());
		playerContext.write(CmdCode._13392, builder.build());
	}

	@CMD(id = CmdCode._13393)
	public void scanRank(PlayerContext playerContext, GReqScanTavernRank msg) {
		
		int rank = tavernRankService.getRank(playerContext.getId());
		
		GResScanTavernRank.Builder builder = GResScanTavernRank.newBuilder();
		builder.setMyRank(rank);
		builder.addAllList(tavernRankService.showRanks(50));
		playerContext.write(CmdCode._13393, builder.build());
	}
}
