/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.promotionNew.handler;

import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.config.excel.cache.promotion.Promotion025BuyGoldSysCache;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion025BuyGold;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion025BuyGold;
import com.ayjs.mxzg.gameserver.module.promotionNew.rank.BuyGoldRankService;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.Promotion025BuyGoldService;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.PromotionControlService;
import com.ayjs.mxzg.protocol.ObjectGMsg.PSMapData;
import com.ayjs.mxzg.protocol.Promotion025GMsg.GReqBuyGoldCountData;
import com.ayjs.mxzg.protocol.Promotion025GMsg.GReqGetBuyGoldReward;
import com.ayjs.mxzg.protocol.Promotion025GMsg.GReqScanBuyGoldRank;
import com.ayjs.mxzg.protocol.Promotion025GMsg.GResBuyGoldCountData;
import com.ayjs.mxzg.protocol.Promotion025GMsg.GResGetBuyGoldReward;
import com.ayjs.mxzg.protocol.Promotion025GMsg.GResScanBuyGoldRank;
import com.ayjs.mxzg.template.constant.ErrorCode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

/**
 * @author YY
 *
 */
@Controller
public class Promotion025BuyGoldHandler extends ProtocolHandler {

	@Autowired
	private Promotion025BuyGoldService promotion025BuyGoldService;
	@Autowired
	private PromotionControlService promotionControlService;
	@Autowired
	private Promotion025BuyGoldSysCache promotion025BuyGoldSysCache;
	@Autowired
    private ThingService thingService;
	@Autowired
	private BuyGoldRankService buyGoldRankService;

	/**
	 * 
	 * @param playerContext
	 * @param msg
	 */
	@CMD(id = CmdCode._13361)
	public void scanBuyGoldInfo(PlayerContext playerContext, GReqBuyGoldCountData msg) {
		Promotion025BuyGold promotion = promotion025BuyGoldService.getPromotionInfo(playerContext.getId());
		
		GResBuyGoldCountData.Builder builder = GResBuyGoldCountData.newBuilder();
		builder.setCount(promotion.getRankCount());
		for(int idx : promotion.getTakeRewards()) {
			//东龙要求的keyvalue
			PSMapData.Builder ele = PSMapData.newBuilder();
			ele.setKey(idx);
			ele.setValue(1);
			builder.addList(ele.build());
		}
		playerContext.write(CmdCode._13361, builder.build());
	}

	/**
	 * 旧协议13075
	 * @param playerContext
	 * @param msg
	 */
	@CMD(id = CmdCode._13362)
	public void getBuyGoldReward(PlayerContext playerContext, GReqGetBuyGoldReward msg) {
		if(!promotionControlService.isPromotionRunning(PromotionType.DIAN_SHI_CHENG_JIN)) {
			//不在活动期间
			playerContext.writeError(ErrorCode.PROMOTION_NOT_RUNNING);
			return;
		}
		Promotion025BuyGold promotion = promotion025BuyGoldService.getPromotionInfo(playerContext.getId());
		
		CPromotion025BuyGold cBuyGold = promotion025BuyGoldSysCache.getByTurnsIdx(promotion.getTurns(), msg.getIdx());
		if(cBuyGold == null) {
			//该奖励不属于当前活动
			playerContext.writeError(ErrorCode.PROMOTION_CONFIG_MISS);
			return;
		}
		if(promotion.getTakeRewards().contains(cBuyGold.getIdx())) {
			//已经领取该奖励
			playerContext.writeError(ErrorCode.PROMOTION_TOOK_REWARD);
			return;
		}
		if(promotion.getRankCount() < cBuyGold.getBuy_gold_times()) {
			//还没有达到领取奖励的要求
			playerContext.writeError(ErrorCode.PROMOTION_CANT_TAKE);
			return;
		}
		promotion.getTakeRewards().add(cBuyGold.getIdx());
		promotion025BuyGoldService.updatePromotion(promotion);

        thingService.add(playerContext.getId(), cBuyGold.getReward(), GameEvent.BUY_GOLD_REWARD);
		
		GResGetBuyGoldReward.Builder builder = GResGetBuyGoldReward.newBuilder();
		builder.setIdx(cBuyGold.getIdx());
		playerContext.write(CmdCode._13362, builder.build());
	}

	/**
	 * 旧协议13074
	 * @param playerContext
	 * @param msg
	 */
	@CMD(id = CmdCode._13363)
	public void scanBuyGoldRank(PlayerContext playerContext, GReqScanBuyGoldRank msg) {
		int rank = buyGoldRankService.getRank(playerContext.getId());
		
		GResScanBuyGoldRank.Builder builder = GResScanBuyGoldRank.newBuilder();
		builder.setMyRank(rank);
		builder.addAllList(buyGoldRankService.showRanks(50));
		playerContext.write(CmdCode._13363, builder.build());
	}
}
