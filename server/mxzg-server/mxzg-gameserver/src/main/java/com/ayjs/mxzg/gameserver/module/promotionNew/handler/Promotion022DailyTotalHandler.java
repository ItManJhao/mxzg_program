/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.promotionNew.handler;

import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.config.excel.cache.promotion.Promotion022DailyTotalRechargeSysCache;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion022DailyTotalRecharge;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion022TotalCharge;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.Promotion022TotalChargeService;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.PromotionControlService;
import com.ayjs.mxzg.protocol.Promotion022GMsg.GReqDailyTotalChargeData;
import com.ayjs.mxzg.protocol.Promotion022GMsg.GReqDailyTotalChargeReward;
import com.ayjs.mxzg.protocol.Promotion022GMsg.GResDailyTotalChargeData;
import com.ayjs.mxzg.protocol.Promotion022GMsg.GResDailyTotalChargeReward;
import com.ayjs.mxzg.template.constant.ErrorCode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

/**
 * @author YY
 *
 */
@Controller
public class Promotion022DailyTotalHandler extends ProtocolHandler {

	@Autowired
	private Promotion022TotalChargeService promotion022TotalChargeService;
	@Autowired
	private Promotion022DailyTotalRechargeSysCache promotion022DailyTotalRechargeSysCache;
	@Autowired
	private PromotionControlService promotionControlService;
	@Autowired
	private ThingService thingService;

	/**
	 * 旧协议20016
	 * @param playerContext
	 * @param msg
	 */
	@CMD(id = CmdCode._13331)
	public void scanTotalChargeInfo(PlayerContext playerContext, GReqDailyTotalChargeData msg) {
		Promotion022TotalCharge totalCharge = promotion022TotalChargeService.getPromotionInfo(playerContext.getId());

		GResDailyTotalChargeData.Builder builder = GResDailyTotalChargeData.newBuilder();
		builder.setMoney(totalCharge.getMoney());
		for (Integer idx : totalCharge.getRewardInfo().keySet()) {
			builder.addList(idx);
		}
		playerContext.write(CmdCode._13331, builder.build());
	}

	/**
	 * 旧协议20017
	 * @param playerContext
	 * @param msg
	 */
	@CMD(id = CmdCode._13332)
	public void getTotalChargeReward(PlayerContext playerContext, GReqDailyTotalChargeReward msg) {
		if (!promotionControlService.isPromotionRunning(PromotionType.MEI_RI_LEI_CHONG)) {
			//不在活动期间
			playerContext.writeError(ErrorCode.PROMOTION_NOT_RUNNING);
			return;
		}
		Promotion022TotalCharge totalCharge = promotion022TotalChargeService.getPromotionInfo(playerContext.getId());

		CPromotion022DailyTotalRecharge cCharge = promotion022DailyTotalRechargeSysCache
				.getByTurnsIdx(totalCharge.getTurns(), msg.getIdx());
		if (cCharge == null) {
			//该奖励不属于当前活动
			playerContext.writeError(ErrorCode.PROMOTION_CONFIG_MISS);
			return;
		}
		if (totalCharge.getRewardInfo().containsKey(cCharge.getIdx())) {
			//今天已经领取过该奖励
			playerContext.writeError(ErrorCode.PROMOTION_TOOK_REWARD);
			return;
		}
		if (cCharge.getRmb() > totalCharge.getMoney()) {
			//还没有达到领取奖励要求
			playerContext.writeError(ErrorCode.PROMOTION_CANT_TAKE);
			return;
		}
		totalCharge.getRewardInfo().put(cCharge.getIdx(), cCharge.getIdx());
		promotion022TotalChargeService.updatePromotion(totalCharge);

		thingService.add(playerContext.getId(), cCharge.getReward(),
				GameEvent.DAILY_TOTAL_RECHARGE);
		
		playerContext.write(CmdCode._13332, GResDailyTotalChargeReward.getDefaultInstance());
	}
}
