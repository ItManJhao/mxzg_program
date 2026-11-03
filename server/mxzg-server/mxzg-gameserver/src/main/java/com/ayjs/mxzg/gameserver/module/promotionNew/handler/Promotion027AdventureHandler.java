/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.promotionNew.handler;

import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.config.excel.cache.promotion.Promotion027AdventureSysCache;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion027Adventure;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion027Adventure;
import com.ayjs.mxzg.gameserver.module.promotionNew.rank.AdventureRankService;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.Promotion027AdventureService;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.PromotionControlService;
import com.ayjs.mxzg.protocol.ObjectGMsg.PSMapData;
import com.ayjs.mxzg.protocol.Promotion027GMsg.GReqAdventureCountData;
import com.ayjs.mxzg.protocol.Promotion027GMsg.GReqGetAdventureReward;
import com.ayjs.mxzg.protocol.Promotion027GMsg.GReqScanAdventureRank;
import com.ayjs.mxzg.protocol.Promotion027GMsg.GResAdventureCountData;
import com.ayjs.mxzg.protocol.Promotion027GMsg.GResGetAdventureReward;
import com.ayjs.mxzg.protocol.Promotion027GMsg.GResScanAdventureRank;
import com.ayjs.mxzg.template.constant.ErrorCode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

/**
 * @author YY
 *
 */
@Controller
public class Promotion027AdventureHandler extends ProtocolHandler {

	@Autowired
	private Promotion027AdventureService promotion027AdventureService;
	@Autowired
	private PromotionControlService promotionControlService;
	@Autowired
    private ThingService thingService;
	@Autowired
	private Promotion027AdventureSysCache promotion027AdventureSysCache;
	@Autowired
	private AdventureRankService adventureRankService;


	@CMD(id = CmdCode._13381)
	public void scanInfo(PlayerContext playerContext, GReqAdventureCountData msg) {
		Promotion027Adventure promotion = promotion027AdventureService.getPromotionInfo(playerContext.getId());
		
		GResAdventureCountData.Builder builder = GResAdventureCountData.newBuilder();
		builder.setCount(promotion.getRankCount());
		for(int idx : promotion.getTakeRewards()) {
			//东龙要求的keyvalue
			PSMapData.Builder ele = PSMapData.newBuilder();
			ele.setKey(idx);
			ele.setValue(1);
			builder.addList(ele.build());
		}
		playerContext.write(CmdCode._13381, builder.build());
	}

	@CMD(id = CmdCode._13382)
	public void getReward(PlayerContext playerContext, GReqGetAdventureReward msg) {
		if(!promotionControlService.isPromotionRunning(PromotionType.SHI_LIAN_ZHI_LU)) {
			//不在活动期间
			playerContext.writeError(ErrorCode.PROMOTION_NOT_RUNNING);
			return;
		}
		Promotion027Adventure promotion = promotion027AdventureService.getPromotionInfo(playerContext.getId());
		
		CPromotion027Adventure cAdventure = promotion027AdventureSysCache.getByTurnsIdx(promotion.getTurns(), msg.getIdx());
		if(cAdventure == null) {
			//该奖励不属于当前活动
			playerContext.writeError(ErrorCode.PROMOTION_CONFIG_MISS);
			return;
		}
		if(promotion.getTakeRewards().contains(cAdventure.getIdx())) {
			//已经领取该奖励
			playerContext.writeError(ErrorCode.PROMOTION_TOOK_REWARD);
			return;
		}
		if(promotion.getRankCount() < cAdventure.getWin_times()) {
			//还没有达到领取奖励的要求
			playerContext.writeError(ErrorCode.PROMOTION_CANT_TAKE);
			return;
		}
		promotion.getTakeRewards().add(cAdventure.getIdx());
		promotion027AdventureService.updatePromotion(promotion);

        thingService.add(playerContext.getId(), cAdventure.getReward(), GameEvent.ADVEN_PATH_GIFT);
		
		GResGetAdventureReward.Builder builder = GResGetAdventureReward.newBuilder();
		builder.setIdx(cAdventure.getIdx());
		playerContext.write(CmdCode._13382, builder.build());
	}

	@CMD(id = CmdCode._13383)
	public void scanRank(PlayerContext playerContext, GReqScanAdventureRank msg) {
		
		int rank = adventureRankService.getRank(playerContext.getId());
		
		GResScanAdventureRank.Builder builder = GResScanAdventureRank.newBuilder();
		builder.setMyRank(rank);
		builder.addAllList(adventureRankService.showRanks(50));
		playerContext.write(CmdCode._13383, builder.build());
	}
}
